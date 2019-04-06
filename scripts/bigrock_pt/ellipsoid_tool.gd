tool
extends Spatial

func value(pos : Vector3):
	var dist_sqr = ((pos - translation) / (scale * 2)).length_squared();
	if dist_sqr > 1.0:
		return -1.0;
	else:
		return (2.0 * (1 - ((22.0/9.0) * dist_sqr) + ((17.0/9.0) * (dist_sqr * dist_sqr)) - ((4.0/9.0) * (dist_sqr * dist_sqr * dist_sqr)))) - 1.0;