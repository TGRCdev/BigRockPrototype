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
export (float) var isovalue = -1.0;
func can_collapse(other):
	return (self.isovalue * other.isovalue) > 0.0;