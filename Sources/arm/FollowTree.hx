package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class FollowTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _StopAgent_001 = new armory.logicnode.StopAgentNode(this);
		_StopAgent_001.preallocInputs(2);
		_StopAgent_001.preallocOutputs(1);
		var _Gate_001 = new armory.logicnode.GateNode(this);
		_Gate_001.property0 = "Equal";
		_Gate_001.property1 = 9.999999747378752e-05;
		_Gate_001.preallocInputs(3);
		_Gate_001.preallocOutputs(2);
		var _OnUpdate_001 = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate_001.property0 = "Update";
		_OnUpdate_001.preallocInputs(0);
		_OnUpdate_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate_001, _Gate_001, 0, 0);
		var _GetDistance_001 = new armory.logicnode.GetDistanceNode(this);
		_GetDistance_001.preallocInputs(2);
		_GetDistance_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _GetDistance_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _GetDistance_001, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetDistance_001, _Gate_001, 0, 1);
		var _Float_001 = new armory.logicnode.FloatNode(this);
		_Float_001.preallocInputs(1);
		_Float_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 1.0), _Float_001, 0, 0);
		armory.logicnode.LogicNode.addLink(_Float_001, _Gate_001, 0, 2);
		armory.logicnode.LogicNode.addLink(_Gate_001, new armory.logicnode.NullNode(this), 1, 0);
		armory.logicnode.LogicNode.addLink(_Gate_001, _StopAgent_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _StopAgent_001, 0, 1);
		armory.logicnode.LogicNode.addLink(_StopAgent_001, new armory.logicnode.NullNode(this), 0, 0);
		var _GotoLocation = new armory.logicnode.GoToLocationNode(this);
		_GotoLocation.preallocInputs(3);
		_GotoLocation.preallocOutputs(1);
		var _OnTimer_001 = new armory.logicnode.OnTimerNode(this);
		_OnTimer_001.preallocInputs(2);
		_OnTimer_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.5), _OnTimer_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _OnTimer_001, 0, 1);
		armory.logicnode.LogicNode.addLink(_OnTimer_001, _GotoLocation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _GotoLocation, 0, 1);
		var _GetObjectLocation = new armory.logicnode.GetLocationNode(this);
		_GetObjectLocation.preallocInputs(2);
		_GetObjectLocation.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _GetObjectLocation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _GetObjectLocation, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetObjectLocation, _GotoLocation, 0, 2);
		armory.logicnode.LogicNode.addLink(_GotoLocation, new armory.logicnode.NullNode(this), 0, 0);
	}
}