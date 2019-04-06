extends Reference

const GRID_VERTS = [
	Vector3(0,0,0),
	Vector3(1,0,0),
	Vector3(0,1,0),
	Vector3(1,1,0),
	Vector3(0,0,1),
	Vector3(1,0,1),
	Vector3(0,1,1),
	Vector3(1,1,1)
]

# Isovalue range is [-1.0, 1.0]
# Isolevel is 0
export (Vector3) var position = Vector3.ZERO;
export (float, -1.0, 1.0) var isovalue = -1.0 setget set_isovalue, get_isovalue;
func can_collapse(other):
	return (self.isovalue * other.isovalue) >= 0.0; # No sign change

func set_isovalue(value):
	isovalue = clamp(value, -1.0, 1.0);

func get_isovalue():
	return isovalue;