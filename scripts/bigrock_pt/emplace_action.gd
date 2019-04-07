extends Reference

export (bool) var remove = false;
export (int, 0, 16) var max_subdiv_level = 4;

func update(t, v):
	var val = t.value(v.position);
	if not remove:
		if val > v.isovalue:
			v.isovalue = val;
	else:
		if -val < v.isovalue:
			v.isovalue = -val;