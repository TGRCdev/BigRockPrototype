extends Node

export (Array, Material) var materials;

onready var cell = Cell.new();

var pressing = false setget set_pressing, get_pressing;

func set_pressing(value):
	var oldval = pressing;
	pressing = value;
	if oldval and not pressing:
		$Draw.draw_cell(cell);

func get_pressing():
	return pressing;

func _ready():
	$Draw.draw_cell(cell);
	$Terrain.mesh = null;

func apply_tool(t : Tool, action : Action):
	cell.apply(t, action);
	cell.try_undivide();
	$Terrain.mesh = MarchingCubes.new().polygonise(cell, materials, 999999);

func clear():
	$Terrain.mesh = null;
	cell = Cell.new();
	$Draw.draw_cell(cell);