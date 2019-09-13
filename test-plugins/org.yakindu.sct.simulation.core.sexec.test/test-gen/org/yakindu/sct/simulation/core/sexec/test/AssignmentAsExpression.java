/** Generated by YAKINDU Statechart Tools code generator. */
package org.yakindu.sct.simulation.core.sexec.test;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.yakindu.sct.model.sexec.ExecutionFlow;
import org.yakindu.sct.model.sexec.interpreter.test.util.AbstractExecutionFlowTest;
import org.yakindu.sct.model.sexec.interpreter.test.util.SExecInjectionProvider;
import org.yakindu.sct.test.models.SCTUnitTestModels;
import com.google.inject.Inject;
import static org.junit.Assert.*;

/**
 * Unit TestCase for AssignmentAsExpression
 */
@SuppressWarnings("all")
@RunWith(XtextRunner.class)
@InjectWith(SExecInjectionProvider.class)
public class AssignmentAsExpression extends AbstractExecutionFlowTest {
	
	@Before
	public void setup() throws Exception{
		ExecutionFlow flow = models.loadExecutionFlowFromResource("AssignmentAsExpression.sct");
		initInterpreter(flow);
	}
	@Test
	public void simpleAssignment() throws Exception {
		interpreter.enter();
		assertTrue(isStateActive("Add"));
		assertTrue(getInteger("b") == 5l);
		assertTrue(getInteger("a") == 9l);
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("Subtract"));
		assertTrue(getInteger("d") == 6l);
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("Multiply"));
		assertTrue(getInteger("e") == 15l);
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("Divide"));
		assertTrue(getInteger("g") == 1l);
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("Modulo"));
		assertTrue(getInteger("i") == 1l);
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("Shift"));
		assertTrue(getInteger("j") == 16l);
		assertTrue(getInteger("k") == 4l);
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("boolean And"));
		assertTrue(getInteger("l") == 1l);
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("boolean Or"));
		assertTrue(getInteger("p") == 15l);
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("boolean Xor"));
		assertTrue(getInteger("u") == 12l);
		interpreter.exit();
	}
}
