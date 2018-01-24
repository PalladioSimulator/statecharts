/**
 * Copyright (c) 2018 committers of YAKINDU and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * Contributors:
 * 	rbeckmann - initial API and implementation
 * 
 */
package org.yakindu.sct.model.sexec.naming

import com.google.inject.Inject
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import com.google.inject.ImplementedBy

/**
 * @author rbeckmann
 *
 */
class TreeStringShortener implements IStringShortener {
	@Accessors(PUBLIC_SETTER) protected int maxLength = 0
	
	@Inject protected extension ShortStringUtils
	@Inject protected TreeServiceNamesValidator validator
	
	protected StringTreeNode tree
	
	protected boolean validState = false
	
	protected Map<StorageToken, String> result
	protected Map<StorageToken, StringTreeNode> storage
	protected Map<StorageToken, List<String>> originalStrings = newHashMap

	override addString(List<String> s) {
		validState = false
		val token = new StorageToken()
		originalStrings.put(token, s)
		return token
	}
	
	override getString(StorageToken token) {
		if(!originalStrings.containsKey(token)) {
			return null
		}
		
		assertValidState()
		
		return result.get(token)
	}
	
	def protected void assertValidState() {
		if(!validState) {
			if(maxLength == 0) {
				result = newHashMap
				originalStrings.keySet.forEach[token |
					result.put(token, originalStrings.get(token).join)
				]
			} else {
				buildTree()
				shortenNames()
			}
			validState = true
		}
	}
	
	def protected buildTree() {
		tree = new StringTreeNode
		storage = newHashMap
		
		originalStrings.keySet.forEach [ token |
			storage.put(token, tree.addStringList(originalStrings.get(token)))
		]
		
		tree.compress()
	}
	
	def protected shortenNames() {
		val List<List<StringTreeNode>> nodes = newArrayList
		val Map<StringTreeNode, List<StringTreeNode>> map = newHashMap
		val Map<StringTreeNode, List<ShortString>> shortStrings = newHashMap
		
		for(node : tree.endNodes) {
			val List<StringTreeNode> list = newArrayList
			list.add(node)
			nodes.add(list)
			map.put(node, list)
			shortStrings.put(node, newArrayList)
		}
		
		buildIndividualNames(nodes)
		
		
		map.keySet.forEach[node |
			shortStrings.get(node).addAll(map.get(node).map[toShortString])
		]
		
		val List<List<ShortString>> shortStringLists = newArrayList(shortStrings.values)
		calculateShortNames(shortStringLists)
		
		storage.keySet.forEach[token |
			result.put(
				token,
				shortStrings.get(storage.get(token)).join
			)
		]
		
	}
	
	def calculateShortNames(List<List<ShortString>> names) {
		validator.names = names
		var longest = names.longestElement
		while(longest.getLength > maxLength && cutOneCharacter(longest)) {
			longest = names.longestElement
		}
	}
	
	def boolean cutOneCharacter(List<ShortString> strings) {
		var ShortString toCut
		var int cheapestCut = Integer.MAX_VALUE
		
		for(part : strings) {
			val oldCost = part.cutCost
			
			part.removeCheapestChar()
		
			val costDifference = part.cutCost - oldCost
			if(validator.validate() && costDifference > 0 && costDifference < cheapestCut) {
				toCut = part
				cheapestCut = costDifference
			}
			part.rollback
		}
		toCut?.removeCheapestChar
		
		return toCut !== null
	}
	
	/** Expand lists until all names are unambiguous. */
	def protected void buildIndividualNames(List<List<StringTreeNode>> nodes) {
		val Map<String, List<List<StringTreeNode>>> map = newHashMap
		
		for(list : nodes) {
			val name = toString(list)
			
			if(!map.containsKey(name)) {
				map.put(name, newArrayList)
			}
			
			map.get(name).add(list)
		}
		
		var abort = true
		for(outer : map.values) {
			if(outer.size > 1) {
				abort = false
				for(inner : outer) {
					val parent = inner.get(0).parent
					if(parent !== null) {
						inner.add(0, parent)
					}
				}
			}
		}
		
		if(abort) {
			return
		}
		
		buildIndividualNames(nodes)
		
	}
	
	def protected String toString(List<StringTreeNode> list) {
		val sb = new StringBuilder
		
		for(node : list) {
			sb.append(node.data)
		}
		
		sb.toString
	}
}