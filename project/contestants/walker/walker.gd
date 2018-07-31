extends KinematicBody

var speed = 1.0
var mouselook = Vector2()
var controls = {"forward": false, "back": false, "left": false, "right": false, "primary": false, "secondary": false}
var input_prefix = ""

func _ready():
	$AnimationPlayer.play("walker-idle-loop", 0.1)

func _physics_process(delta):
	rotate_y(-mouselook.x)
	$Camera.rotation.x = clamp($Camera.rotation.x - mouselook.y, -1.57, 1.57)
	#$Camera.rotate_x(-mouselook.y)
	mouselook = Vector2()

	var move = Vector3()

	var anim = $AnimationPlayer.current_animation
	var pos = $AnimationPlayer.current_animation_position

	var basis = global_transform.basis

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

	if anim == "walker-walk-loop" and pos > 0.2 and pos < 0.8:
		move_and_slide(move * speed + Vector3(0, -5, 0), Vector3(0, 1, 0))
	else:
		move_and_slide(Vector3(0, -5, 0), Vector3(0, 1, 0))

	if is_on_floor() and move.length():
		if anim != "walker-walk-loop":
			$AnimationPlayer.play("walker-walk-loop")

	elif anim != "walker-idle-loop":
		$AnimationPlayer.play("walker-idle-loop", 0.1)