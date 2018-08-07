extends KinematicBody

var hp = 5
var speed = 0.8
var mouselook = Vector2()
var controls = {"forward": false, "back": false, "left": false, "right": false, "primary": false, "secondary": false}
var input_prefix = ""
var shoot_timer = 0.0
var next_weapon = 0
var weapons = []
var speed_factor = 1.0
onready var cam = get_node("Camera")

func _ready():
	$AnimationPlayer.play("wheelchair-idle-loop", 0.1)

	if !has_node("KeyboardMouse"):
		controls['forward'] = true

func damage(value):
	if hp <= 0:
		return

	hp -= value
	if hp <= 0:
		queue_free()

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
		$"WheelChair/Wheel-BL".rotate_x(0.02 * speed_factor)
		$"WheelChair/Wheel-BR".rotate_x(-0.02 * speed_factor)
	if controls['right']:
		look -= 0.01
		$"WheelChair/Wheel-BL".rotate_x(-0.02 * speed_factor)
		$"WheelChair/Wheel-BR".rotate_x(0.02 * speed_factor)

	rotate_y(look)

	cam.rotation.y = clamp(cam.rotation.y - mouselook.x, -1.57, 1.57)
	cam.rotation.x = clamp(cam.rotation.x - mouselook.y, -1.57, 1.57)
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

	#if anim == "wheelchair-move-loop" and pos > 0.2 and pos < 0.8:
	move_and_slide(move * speed * speed_factor + Vector3(0, -5, 0), Vector3(0, 1, 0))
	#else:
	#	move_and_slide(Vector3(0, -5, 0), Vector3(0, 1, 0))
	$AnimationPlayer.playback_speed = speed_factor

	if move.length():
		#speed_factor = clamp(speed_factor + delta, 1.0, 3.0)
		$"WheelChair/Wheel-BL".rotate_x(-0.02 * speed_factor)
		$"WheelChair/Wheel-BR".rotate_x(-0.02 * speed_factor)
		if anim != "wheelchair-move-loop":
			$AnimationPlayer.play("wheelchair-move-loop")

	elif anim != "wheelchair-idle-loop":
		#speed_factor = 1.0
		$AnimationPlayer.play("wheelchair-idle-loop", 0.1)

	if shoot_timer > 0.0:
		shoot_timer = max(shoot_timer - delta, 0.0)

	if controls['primary'] and shoot_timer == 0.0:
		fire()
		shoot_timer = 0.15