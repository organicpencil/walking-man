extends MeshInstance

var explosion_scn = preload("res://effects/explosion.tscn")
var timer = 0.0

func _ready():
	pass

func _physics_process(delta):
	# FIXME - Use interpolation in _process if it's too choppy
	var move = transform.basis * Vector3(0.0, 0.0, -50.0) * delta
	#raycast to translation + move

	timer += delta

	if timer > 3.0:
		queue_free()
		return

	var space_state = get_world().get_direct_space_state()
	var result = space_state.intersect_ray(translation, translation + move + transform.basis * Vector3(0.0, 0.0, -1.0))

	if !result.empty():
		var other = result["collider"]

		if other.has_method("damage"):
			other.damage(5000)

		var explosion = explosion_scn.instance()
		get_viewport().add_child(explosion)
		explosion.global_transform.origin = result['position'] + (result['normal'] * 0.5)

		queue_free()
		return

	global_translate(move)