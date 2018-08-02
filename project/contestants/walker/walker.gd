extends KinematicBody

var speed = 0.4
var mouselook = Vector2()
var controls = {"forward": false, "back": false, "left": false, "right": false, "primary": false, "secondary": false}
var input_prefix = ""
var shoot_timer = 0.0
var next_weapon = 0
var weapons = []

func _ready():
	$AnimationPlayer.play("walker-idle-loop", 0.1)

func fire():
	if weapons.size() == 0:
		return

	var wep = weapons[next_weapon].get_ref()
	next_weapon += 1
	if next_weapon >= weapons.size():
		next_weapon = 0

	wep.fire()

func _physics_process(delta):
	var look = 0.0
	if controls['left']:
		look += 0.01
	if controls['right']:
		look -= 0.01

	rotate_y(look)

	$Camera.rotation.y = clamp($Camera.rotation.y - mouselook.x, -1.57, 1.57)
	$Camera.rotation.x = clamp($Camera.rotation.x - mouselook.y, -1.57, 1.57)
	mouselook = Vector2()

	var move = Vector3()

	var anim = $AnimationPlayer.current_animation
	var pos = $AnimationPlayer.current_animation_position

	var basis = global_transform.basis

	if controls['forward']:
		move += -basis[2]

	"""
	if controls['back']:
		move += basis[2]

	if controls['left']:
		move += -basis[0]

	if controls['right']:
		move += basis[0]
	"""

	move.y = 0
	move = move.normalized()

	if anim == "walker-walk-loop" and pos > 0.2 and pos < 0.8:
		move_and_slide(move * speed + Vector3(0, -5, 0), Vector3(0, 1, 0))
	else:
		move_and_slide(Vector3(0, -5, 0), Vector3(0, 1, 0))

	if is_on_floor() and move.length():
		if anim != "walker-walk-loop":
			$AnimationPlayer.play("walker-walk-loop")

	elif anim != "walker-idle-loop":
		$AnimationPlayer.play("walker-idle-loop", 0.1)

	if shoot_timer > 0.0:
		shoot_timer = max(shoot_timer - delta, 0.0)

	if controls['primary'] and shoot_timer == 0.0:
		fire()
		shoot_timer = 0.075