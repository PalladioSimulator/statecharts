/**
 *   Copyright (c) 2016 committers of YAKINDU Statechart Tools.
 *   All rights reserved. This program and the accompanying materials
 *   are made available under the terms of the Eclipse Public License v1.0
 *   which accompanies this distribution, and is available at
 *   http://www.eclipse.org/legal/epl-v10.html
 *   
 *   Contributors:
 * 		@author René Beckmann (beckmann@itemis.de)
 */

package org.yakindu.sct.model.sexec.naming

import com.google.common.collect.Maps
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import javax.inject.Inject
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.yakindu.base.base.NamedElement
import org.yakindu.sct.model.sexec.ExecutionFlow
import org.yakindu.sct.model.sexec.ExecutionScope
import org.yakindu.sct.model.sexec.ExecutionState
import org.yakindu.sct.model.sexec.Step
import org.yakindu.sct.model.sexec.extensions.SExecExtensions
import org.yakindu.sct.model.sexec.transformation.StatechartExtensions
import org.yakindu.sct.model.sgraph.CompositeElement
import org.yakindu.sct.model.sgraph.Region
import org.yakindu.sct.model.sgraph.State
import org.yakindu.sct.model.sgraph.Statechart
import org.yakindu.sct.model.sgraph.Vertex
import org.yakindu.sct.model.stext.stext.TimeEventSpec

/** New implementation of the naming service for various identifiers used in the generated code. 
 * It is responsible for identifier construction depending on the thing to be named including different strategies 
 * which also include name shortening.
 */
class TreeNamingService implements INamingService {
	@Accessors protected int maxLength = 0;
	@Accessors protected char separator = '_';

	@Inject extension SExecExtensions
	@Inject extension StatechartExtensions
	@Inject extension IQualifiedNameProvider

	@Inject extension ElementNameProvider

	@Inject protected StringTreeNodeDepthComparator stringTreeNodeDepthComparator
	
	@Inject protected IStringShortener shortener

	// from public class org.yakindu.sct.generator.c.features.CDefaultFeatureValueProvider extends		
	protected static final String VALID_IDENTIFIER_REGEX = "[_a-zA-Z][_a-zA-Z0-9]*";



	/*
	 * Holds the name of each element whose name was requested.
	 */
	protected Map<NamedElement, String> map
	
	protected Map<NamedElement, StorageToken> tokens

	// if the naming service is initialized with a flow, activeStatechart is null, and vice versa.
	protected ExecutionFlow activeFlow;
	protected Statechart activeStatechart;

	new(int maxLength, char separator) {
		this.maxLength = maxLength
		this.separator = separator
	}

	new() {
		this.maxLength = 0
		this.separator = '_'
	}

	override initializeNamingService(Statechart statechart) {
		if (activeStatechart != statechart) {
			map = Maps.newHashMap
			activeFlow = null;
			activeStatechart = statechart;
			
			collectNames(statechart)
		}
	}

	def protected void collectNames(CompositeElement element) {
		for (region : element.regions) {
			addElement(region, new ArrayList<String>(), new ArrayList<String>());
			for (vertex : region.vertices) {
				switch vertex {
					State:
						addElement(vertex, new ArrayList<String>(), new ArrayList<String>())
					default:
						addElement(vertex, new ArrayList<String>(), new ArrayList<String>())
				}
			}
		}
		for (region : element.regions) {
			for (vertex : region.vertices) {
				if (vertex instanceof CompositeElement) {
					collectNames(vertex as CompositeElement)
				}
			}
		}
	}

	override initializeNamingService(ExecutionFlow flow) {
		if (activeFlow != flow) {
			map = Maps.newHashMap
			activeFlow = flow;
			activeStatechart = null;

			collectNames(flow);
		}
	}

	def protected void collectNames(ExecutionFlow flow) {

		for (region : flow.regions) {
			addElement(region, new ArrayList<String>(), new ArrayList<String>());
			for (node : region.nodes) {
				addElement(node, new ArrayList<String>(), new ArrayList<String>());
			}
		}

		for (state : flow.states) {
			addElement(state, state.prefix, state.suffix);
		}
		for (func : flow.allFunctions) {
			addElement(func, func.prefix, func.suffix);
		}

		// Create short name for time events of statechart
		if (flow.sourceElement instanceof Statechart) {
			val statechart = flow.sourceElement as Statechart
			addShortTimeEventName(flow, statechart)
		}

		// Create short name for time events of states
		for (executionState : flow.states) {
			if (executionState.sourceElement instanceof State) {
				val state = executionState.sourceElement as State
				addShortTimeEventName(executionState, state)
			}
		}
	}

	def protected addShortTimeEventName(NamedElement executionFlowElement, NamedElement sgraphElement) {
		var timeEventSpecs = sgraphElement.timeEventSpecs;
		for (tes : timeEventSpecs) {
			val timeEvent = executionFlowElement.flow.getTimeEvent(sgraphElement.fullyQualifiedName + "_time_event_" +
				timeEventSpecs.indexOf(tes))
			if (timeEvent !== null) {
				addElement(executionFlowElement, prefix(tes, sgraphElement), suffix(tes, sgraphElement));
			}
		}
	}

	def protected void addElement(NamedElement elem, List<String> prefix, List<String> suffix) {
		val name = new ArrayList<String>(elem.elementNameSegments());
		val segments = new ArrayList<String>();
		segments.addAll(prefix);
		segments.addAll(name);
		segments.addAll(suffix);
		if (!segments.isEmpty()) {
			tokens.put(elem, shortener.addString(addSeparator(segments)))
		}
	// System.out.println(name);
	}

	def protected asIndexPosition(ExecutionScope it) {
		superScope.subScopes.indexOf(it).toString;
	}

	def protected dispatch asSGraphIndexPosition(Region it) {
		composite.regions.toList.indexOf(it).toString
	}

	def protected dispatch asSGraphIndexPosition(State it) {
		parentRegion.vertices.filter(typeof(State)).toList.indexOf(it).toString
	}

	def protected dispatch asSGraphIndexPosition(Vertex it) {
		parentRegion.vertices.toList.indexOf(it).toString
	}

	override public setMaxLength(int length) {
		maxLength = length
		shortener.maxLength = length
	}

	override public setSeparator(char sep) {
		// Check if Prefix is ok		
		var String sepString = sep + ""
		if (!(sepString.matches(VALID_IDENTIFIER_REGEX))) {
			throw new IllegalArgumentException
		}
		separator = sep
	}

	override getShortName(NamedElement element) {
		// check if element was named before
		if (map.containsKey(element)) {
			return map.get(element);
		}
		// if not, check if element is located in the shortener
		if (!tokens.containsKey(element)) {
			addElement(element, new ArrayList<String>(), new ArrayList<String>());
		}

		val name = shortener.getString(tokens.get(element))

		map.put(element, name);
		return name;
	}

	override asEscapedIdentifier(String string) {
		asIdentifier(string);
	}

	override asIdentifier(String string) {
		string.replaceAll('[^a-z&&[^A-Z&&[^0-9]]]', separator.toString)
	}

	override isKeyword(String string) {
		return false;
	}

	override getShortNameMap(Statechart statechart) {
		initializeNamingService(statechart)
		return map
	}

	override getShortNameMap(ExecutionFlow flow) {
		initializeNamingService(flow)
		return map
	}

	def protected suffix(Step it) {
		var l = new ArrayList<String>();

		switch (it) {
			case isCheckFunction: {
				l.add("check");
			}
			case isEntryAction: {
				l.add("enact");
			}
			case isExitAction: {
				l.add("exact");
			}
			case isEffect: {
				l.add("effect");
			}
			case isEnterSequence: {
				l.add("enseq");
			}
			case isDeepEnterSequence: {
				l.add("dhenseq");
			}
			case isShallowEnterSequence: {
				l.add("shenseq");
			}
			case isExitSequence: {
				l.add("exseq");
			}
			case isReactSequence: {
				l.add("react");
			}
			default: {
			}
		}

		return l;
	}

	def protected prefix(Step it) {
		return new ArrayList<String>();
	}

	def protected prefix(ExecutionState it) {
		var l = new ArrayList<String>();
		// l.add(flow.name);
		return l;
	}

	def protected suffix(ExecutionState it) {
		return new ArrayList<String>();
	}

	def protected prefix(TimeEventSpec it, NamedElement element) {
		var l = new ArrayList<String>();
		// l.add(activeFlow.name);
		return l;
	}

	def protected suffix(TimeEventSpec it, NamedElement element) {
		var l = new ArrayList<String>();
		switch (element) {
			Statechart: {
				l.add("tev" + element.timeEventSpecs.indexOf(it));
			}
			State: {
				l.add("tev" + element.timeEventSpecs.indexOf(it));
			}
		}
		return l;
	}

	def protected prefix(State it) {
		var l = new ArrayList<String>();
		// l.add(activeStatechart.name);
		return l;
	}

	def protected prefix(Vertex it) {
		return new ArrayList<String>();
	}

	def protected suffix(Vertex it) {
		return new ArrayList<String>();
	}
	
	def protected List<String> addSeparator(List<String> segments) {
		val List<String> result = newArrayList
		for(var i = 0; i < segments.size(); i++) {
			result.add(segments.get(i)) {
				if(i < segments.size() - 1) {
					result.add(separator.toString)
				}
			}
			
		}
		result
	}
}
