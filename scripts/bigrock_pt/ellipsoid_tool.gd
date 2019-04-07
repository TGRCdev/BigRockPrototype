tool
extends Spatial

func get_tool_aabb():
	var gverts = [Vector3(-1, -1, -1), Vector3(1, -1, -1), Vector3(-1, 1, -1), Vector3(1, 1, -1), Vector3(-1, -1, 1), Vector3(1, -1, 1), Vector3(-1, 1, 1), Vector3(1,1,1)];
	var minpos = global_transform.xform(gverts[0]);
	var maxpos = global_transform.xform(gverts[0]);
	
	for i in range(1, 8):
		var pos = global_transform.xform(gverts[i]);
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
	return ret;

func value(pos : Vector3):
	var dist_sqr = ((pos - translation) / (scale * 2)).length_squared();
	if dist_sqr > 1.0:
		return -1.0;
	else:
		return (2.0 * (1 - ((22.0/9.0) * dist_sqr) + ((17.0/9.0) * (dist_sqr * dist_sqr)) - ((4.0/9.0) * (dist_sqr * dist_sqr * dist_sqr)))) - 1.0;