package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class NavigateTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _Print = new armory.logicnode.PrintNode(this);
		_Print.preallocInputs(2);
		_Print.preallocOutputs(1);
		var _GotoLocation = new armory.logicnode.GoToLocationNode(this);
		_GotoLocation.preallocInputs(3);
		_GotoLocation.preallocOutputs(1);
		var _Mouse_001 = new armory.logicnode.MergedMouseNode(this);
		_Mouse_001.property0 = "released";
		_Mouse_001.property1 = "left";
		_Mouse_001.preallocInputs(0);
		_Mouse_001.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(_Mouse_001, new armory.logicnode.BooleanNode(this, false), 1, 0);
		armory.logicnode.LogicNode.addLink(_Mouse_001, _GotoLocation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Cube"), _GotoLocation, 0, 1);
		var _PickNavMeshLocation = new armory.logicnode.PickLocationNode(this);
		_PickNavMeshLocation.preallocInputs(2);
		_PickNavMeshLocation.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Plane"), _PickNavMeshLocation, 0, 0);
		var _Vector = new armory.logicnode.VectorNode(this);
		_Vector.preallocInputs(3);
		_Vector.preallocOutputs(1);
		var _GetCursorLocation = new armory.logicnode.GetCursorLocationNode(this);
		_GetCursorLocation.preallocInputs(0);
		_GetCursorLocation.preallocOutputs(4);
		armory.logicnode.LogicNode.addLink(_GetCursorLocation, new armory.logicnode.IntegerNode(this, 0), 2, 0);
		armory.logicnode.LogicNode.addLink(_GetCursorLocation, new armory.logicnode.IntegerNode(this, 0), 3, 0);
		armory.logicnode.LogicNode.addLink(_GetCursorLocation, _Vector, 0, 0);
		armory.logicnode.LogicNode.addLink(_GetCursorLocation, _Vector, 1, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.0), _Vector, 0, 2);
		armory.logicnode.LogicNode.addLink(_Vector, _PickNavMeshLocation, 0, 1);
		armory.logicnode.LogicNode.addLink(_PickNavMeshLocation, _GotoLocation, 0, 2);
		armory.logicnode.LogicNode.addLink(_GotoLocation, _Print, 0, 0);
		armory.logicnode.LogicNode.addLink(_PickNavMeshLocation, _Print, 0, 1);
		armory.logicnode.LogicNode.addLink(_Print, new armory.logicnode.NullNode(this), 0, 0);
	}
}