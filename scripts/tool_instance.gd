extends Spatial

onready var t = EllipsoidTool.new();
onready var action = Action.new();

func _ready():
	set_action_type(Action.ACTION_TYPE_EMPLACE);
	action.max_subdiv_level = 3;

func set_action_type(type):
	action.action_type = type;

func _process(delta):
	t.transform = self.global_transform;
	t.scale = self.scale;

func get_tool() -> Tool:
	return t;

func value(point : Vector3) -> float:
	return t.value(point);