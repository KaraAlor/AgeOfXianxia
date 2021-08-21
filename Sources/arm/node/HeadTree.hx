package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class HeadTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		name = "HeadTree";
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _PlayActionFrom = new armory.logicnode.PlayActionFromNode(this);
		_PlayActionFrom.preallocInputs(7);
		_PlayActionFrom.preallocOutputs(2);
		var _OnInit = new armory.logicnode.OnInitNode(this);
		_OnInit.preallocInputs(0);
		_OnInit.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnInit, _PlayActionFrom, 0, 0);
		var _SelfObject = new armory.logicnode.SelfNode(this);
		_SelfObject.preallocInputs(0);
		_SelfObject.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_SelfObject, _PlayActionFrom, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "RelaxedIdle"), _PlayActionFrom, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 0), _PlayActionFrom, 0, 3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 1.0), _PlayActionFrom, 0, 4);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 1.0), _PlayActionFrom, 0, 5);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _PlayActionFrom, 0, 6);
		armory.logicnode.LogicNode.addLink(_PlayActionFrom, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_PlayActionFrom, new armory.logicnode.NullNode(this), 1, 0);
	}
}