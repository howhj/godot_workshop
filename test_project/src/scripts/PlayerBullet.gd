extends KinematicBody2D

export var speed = 1000

func _physics_process(delta):
	var velocity = Vector2(0, -speed)
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
