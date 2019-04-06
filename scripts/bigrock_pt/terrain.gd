extends Reference

const Cell = preload("res://scripts/bigrock_pt/cell.gd");
const Vertex = Cell.Vertex;
const EllipsoidTool = preload("res://scripts/bigrock_pt/ellipsoid_tool.gd");
const EmplaceAction = preload("res://scripts/bigrock_pt/emplace_action.gd");

static func interpolate_vertices(vert1, vert2, t):
	var ret = Vertex.new();
	if t < 0.0:
		ret.isovalue = vert1.isovalue;
		ret.position = vert1.position;
	elif t > 1.0:
		ret.isovalue = vert2.isovalue;
		ret.position = vert2.position;
	else:
		ret.isovalue = lerp(vert1.isovalue, vert2.isovalue, t);
		ret.position = vert1.position.linear_interpolate(vert2.position, t);
	return ret;

static func sample_cell(cell, pos:Vector3):
		if cell.is_leaf():
			var t = (pos - cell.vertices[0].position) / (cell.vertices[7].position - cell.vertices[0].position);
			var xplane = [
				interpolate_vertices(cell.vertices[0], cell.vertices[1], t.x),
				interpolate_vertices(cell.vertices[2], cell.vertices[3], t.x),
				interpolate_vertices(cell.vertices[4], cell.vertices[5], t.x),
				interpolate_vertices(cell.vertices[6], cell.vertices[7], t.x)
			]
			
			var yline = [
				interpolate_vertices(xplane[0], xplane[1], t.y),
				interpolate_vertices(xplane[2], xplane[3], t.y),
			]
			
			return interpolate_vertices(yline[0], yline[1], t.z);
		else:
			return sample_cell(cell.children[cell.get_index_containing_pos(pos)], pos);

static func subdivide_cell(cell):
	if not cell.is_leaf():
		return;
	
	# Step 1: Setup vertices
	var vert_dict = Dictionary();
	for i in range(0, 8):
		vert_dict[Vertex.GRID_VERTS[i]] = cell.vertices[i];
	
	for x in range(0, 3):
		for y in range(0, 3):
			for z in range(0, 3):
				var pos = Vector3(x, y, z) / 2;
				if not vert_dict.has(pos):
					vert_dict[pos] = sample_cell(cell, cell.vertices[0].position + ((cell.vertices[7].position - cell.vertices[0].position) * pos))
	
	# Step 2: Add children
	
	cell.children = Array();
	cell.children.resize(8);
	
	for i in range(0, 8):
		var child = Cell.new();
		child.subdiv_level = cell.subdiv_level + 1;
		child.vertices = Array();
		child.vertices.resize(8);
		var relpos = Vertex.GRID_VERTS[i] / 2;
		for j in range(0, 8):
			var vertpos = relpos + (Vertex.GRID_VERTS[j] / 2);
			child.vertices[j] = vert_dict[vertpos]
		cell.children[i] = child;

static func undivide_cell(cell):
	if cell.is_leaf():
		return;
	
	cell.children.clear();
	cell.children = null;

static func try_undivide(cell, recursive=false):
	if cell.is_leaf():
		return;
	
	var collapse = true;
	
	for i in range(0, 7):
		if not cell.children[i].is_leaf():
			if recursive:
				try_undivide(cell.children[i], true)
			else:
				return;
	
		if cell.children[i].is_leaf():
			collapse = collapse and cell.children[i].can_collapse();
			collapse = collapse and cell.children[i].vertices[7].can_collapse(cell.children[i+1].vertices[0]);
			if not collapse:
				break;
		else:
			return;
	
	if collapse:
		undivide_cell(cell);

static func get_tool_aabb(t : Spatial) -> AABB:
	var gverts = Cell.Vertex.GRID_VERTS;
	var minpos = t.global_transform.xform(gverts[0]);
	var maxpos = t.global_transform.xform(gverts[0]);
	
	for i in range(1, 8):
		var pos = t.transform.xform(gverts[i]);
		if pos.x < minpos.x:
			minpos.x = pos.x;
		elif pos.x > maxpos.x:
			maxpos.x = pos.x;
		
		if pos.y < minpos.y:
			minpos.y = pos.y;
		elif pos.y > maxpos.y:
			maxpos.y = pos.y;
		
		if pos.z < minpos.z:
			minpos.z = pos.z;
		elif pos.z > maxpos.z:
			maxpos.z = pos.z;
	
	var ret = AABB();
	ret.position = minpos;
	ret.end = maxpos;
	print("%s = %s" % [t.scale, ret.size]);
	return ret;

static func get_cell_aabb(cell) -> AABB:
	var ret = AABB();
	ret.position = cell.vertices[0].position;
	ret.end = cell.vertices[7].position;
	return ret;

static func cell_apply_tool(cell, t, a):
	for vertex in cell.vertices:
		a.update(t, vertex);

	if cell.is_leaf() and cell.subdiv_level < a.max_subdiv_level:
		subdivide_cell(cell);
	
	if not cell.is_leaf():
		var tool_aabb = get_tool_aabb(t);
		for child in cell.children:
			if tool_aabb.intersects(get_cell_aabb(child)):
				cell_apply_tool(child, t, a);