extends Reference

const Vertex = preload("res://scripts/bigrock_pt/vertex.gd");

export (Array) var vertices = null;
export (Array) var children = null;
export var subdiv_level = 0;

func init_verts(pos=Vector3.ZERO):
	vertices = Array();
	vertices.resize(8);
	for i in range(0, 8):
		var vert = Vertex.new();
		vert.position = pos + (Vertex.GRID_VERTS[i] / pow(2,subdiv_level));
		vertices[i] = vert;

func is_leaf():
	return children == null;

func can_collapse():
	if not is_leaf():
		return false;
	
	var collapse = true;
	
	for i in range (0, 7):
		collapse = collapse and vertices[i].can_collapse(vertices[i+1]);
		if not collapse:
			break;
	
	return collapse;

func get_index_containing_pos(pos:Vector3):
	var midpoint = vertices[0].position.linear_interpolate(vertices[7].position, 0.5);
	var index = 0;
	if pos.x > midpoint.x:
		index |= 1;
	if pos.y > midpoint.y:
		index |= 2;
	if pos.z > midpoint.z:
		index |= 4;
	return index;