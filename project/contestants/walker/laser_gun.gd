extends MeshInstance

var laser_scn = preload("res://contestants/walker/laser.tscn")
export(NodePath) var person = null

func _ready():
	person = get_node(person)
	assert(person != null)

	person.weapons.append(weakref(self))

func fire():
	var laser = laser_scn.instance()
	person.get_parent().add_child(laser)
	laser.global_transform.origin = global_transform.origin
	laser.global_transform.basis = global_transform.basis

	laser.rotate_x(rand_range(-0.05, 0.05))
	laser.rotate_y(rand_range(-0.05, 0.05))
	laser.rotate_z(rand_range(-0.05, 0.05))