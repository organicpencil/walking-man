extends KinematicBody

var hp = 5
var speed = 2.0
var mouselook = Vector2()
var controls = {"forward": false, "back": false, "left": false, "right": false, "primary": false, "secondary": false}
var input_prefix = ""
onready var cam = get_node("Camera")

func _ready():
	$AnimationPlayer2.play("person-idle-arms-loop")

	if !has_node("KeyboardMouse"):
		controls['forward'] = true

func damage(value):
	if hp <= 0:
		return

	hp -= value
	if hp <= 0:
		queue_free()

func _physics_process(delta):
	rotate_y(-mouselook.x)
	$Camera.rotation.x = clamp($Camera.rotation.x - mouselook.y, -1.57, 1.57)
	#$Camera.rotate_x(-mouselook.y)
	mouselook = Vector2()

	var basis = global_transform.basis
	var move = Vector3()

	if controls['forward']:
		move += -basis[2]

	if controls['back']:
		move += basis[2]

	if controls['left']:
		move += -basis[0]

	if controls['right']:
		move += basis[0]

	move.y = 0
	move = move.normalized()
	move_and_slide(move * speed + Vector3(0, -5, 0), Vector3(0, 1, 0))

	var anim = $AnimationPlayer.current_animation
	if is_on_floor() and move.length():
		if anim != "person-walk-loop":
			$AnimationPlayer.play("person-walk-loop", 0.1)
	elif anim != "person-idle-loop":
		$AnimationPlayer.play("person-idle-loop", 0.1)