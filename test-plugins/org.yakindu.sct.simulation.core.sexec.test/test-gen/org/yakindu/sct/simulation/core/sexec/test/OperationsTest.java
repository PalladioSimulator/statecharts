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
import java.util.Collections;
import com.google.common.collect.Lists;
import org.yakindu.sct.simulation.core.sexec.interpreter.DefaultOperationMockup;

/**
 * Unit TestCase for Operations
 */
@SuppressWarnings("all")
@RunWith(XtextRunner.class)
@InjectWith(SExecInjectionProvider.class)
public class OperationsTest extends AbstractExecutionFlowTest {
	@Inject DefaultOperationMockup mockUp;
	
	@Before
	public void setup() throws Exception{
		ExecutionFlow flow = models.loadExecutionFlowFromResource("Operations.sct");
		initInterpreter(flow);
	}
	@Test
	public void operationsCalled() throws Exception {
		mockUp.mockReturnValue("alwaysTrue", Lists.newArrayList(), true);
		interpreter.enter();
		assertTrue(isStateActive("A"));
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("B"));
		assertTrue(mockUp.wasCalledAtLeast("internalOperation1", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("InternalOperation2", Lists.newArrayList(4l), null));
		assertTrue(mockUp.wasCalledAtLeast("internalOperation3", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("internalOperation3a", Lists.newArrayList(1.0), null));
		assertTrue(mockUp.wasCalledAtLeast("internalOperation4", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("internalOperation4a", Lists.newArrayList(5l), null));
		assertTrue(mockUp.wasCalledAtLeast("internalOperation5", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("internalOperation5a", Collections.emptyList(), null));
		raiseEvent("ev");
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("C"));
		assertTrue(mockUp.wasCalledAtLeast("interfaceOperation1", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("InterfaceOperation2", Lists.newArrayList(4l), null));
		assertTrue(mockUp.wasCalledAtLeast("interfaceOperation3", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("interfaceOperation3a", Lists.newArrayList(1.0), null));
		assertTrue(mockUp.wasCalledAtLeast("interfaceOperation4", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("interfaceOperation4a", Lists.newArrayList(5l), null));
		assertTrue(mockUp.wasCalledAtLeast("interfaceOperation5", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("interfaceOperation5a", Collections.emptyList(), null));
		raiseEvent("ev");
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("D"));
		assertTrue(mockUp.wasCalledAtLeast("unnamedInterfaceOperation1", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("UnnamedInterfaceOperation2", Lists.newArrayList(4l), null));
		assertTrue(mockUp.wasCalledAtLeast("unnamedOperation3", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("unnamedOperation3a", Lists.newArrayList(1.0), null));
		assertTrue(mockUp.wasCalledAtLeast("unnamedOperation4", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("unnamedOperation4a", Lists.newArrayList(5l), null));
		assertTrue(mockUp.wasCalledAtLeast("unnamedOperation5", Collections.emptyList(), null));
		assertTrue(mockUp.wasCalledAtLeast("unnamedOperation5a", Collections.emptyList(), null));
	}
	@Test
	public void operationsNotCalled() throws Exception {
		mockUp.mockReturnValue("alwaysTrue", Lists.newArrayList(), true);
		interpreter.enter();
		assertTrue(isStateActive("A"));
		assertTrue(mockUp.wasNotCalled("internalOperation1", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("InternalOperation2", Lists.newArrayList(4l)));
		assertTrue(mockUp.wasNotCalled("internalOperation3", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("internalOperation3a", Lists.newArrayList(1.0)));
		assertTrue(mockUp.wasNotCalled("internalOperation4", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("internalOperation4a", Lists.newArrayList(5l)));
		assertTrue(mockUp.wasNotCalled("internalOperation5", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("internalOperation5a", Collections.emptyList()));
		raiseEvent("ev");
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("B"));
		assertTrue(mockUp.wasNotCalled("interfaceOperation1", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("InterfaceOperation2", Lists.newArrayList(4l)));
		assertTrue(mockUp.wasNotCalled("interfaceOperation3", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("interfaceOperation3a", Lists.newArrayList(1.0)));
		assertTrue(mockUp.wasNotCalled("interfaceOperation4", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("interfaceOperation4a", Lists.newArrayList(5l)));
		assertTrue(mockUp.wasNotCalled("interfaceOperation5", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("interfaceOperation5a", Collections.emptyList()));
		raiseEvent("ev");
		timer.timeLeap(getCyclePeriod());
		assertTrue(isStateActive("C"));
		assertTrue(mockUp.wasNotCalled("unnamedInterfaceOperation1", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("UnnamedInterfaceOperation2", Lists.newArrayList(4l)));
		assertTrue(mockUp.wasNotCalled("unnamedOperation3", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("unnamedOperation3a", Lists.newArrayList(1.0)));
		assertTrue(mockUp.wasNotCalled("unnamedOperation4", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("unnamedOperation4a", Lists.newArrayList(5l)));
		assertTrue(mockUp.wasNotCalled("unnamedOperation5", Collections.emptyList()));
		assertTrue(mockUp.wasNotCalled("unnamedOperation5a", Collections.emptyList()));
	}
}
