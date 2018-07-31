extends Node

export var input_prefix = ""

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		get_parent().mouselook += event.relative * 0.001

	if event.is_action_pressed("quit"): # FIXME - Doesn't belong here
		get_tree().quit()

func _process(delta):
	get_viewport().get_node("Control/Viewport1/Camera").global_transform = get_node("../Camera").global_transform

	var controls = get_parent().controls
	controls['forward'] = Input.is_action_pressed(input_prefix + "forward")
	controls['back'] = Input.is_action_pressed(input_prefix + "back")
	controls['left'] = Input.is_action_pressed(input_prefix + "left")
	controls['right'] = Input.is_action_pressed(input_prefix + "right")
	controls['primary'] = Input.is_action_pressed(input_prefix + "primary")
	controls['secondary'] = Input.is_action_pressed(input_prefix + "secondary")