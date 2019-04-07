extends Spatial

export var noise : OpenSimplexNoise;

func _ready():
	if not noise:
		noise = OpenSimplexNoise.new();
	noise.seed = OS.get_unix_time();

func value(pos : Vector3):
	return noise.get_noise_3dv(global_transform.xform(pos));

func get_tool_aabb():
	var ret = AABB();
	ret.position = Vector3(-999,-999,-999);
	ret.end = Vector3(999,999,999);
	return ret;