extends Sprite3D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "finished")
	$AnimationPlayer.play("explode")

func finished(anim):
	queue_free()