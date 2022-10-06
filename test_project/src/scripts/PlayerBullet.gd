extends KinematicBody2D

export var speed = 1000
var direction = Vector2(0,-1)

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
