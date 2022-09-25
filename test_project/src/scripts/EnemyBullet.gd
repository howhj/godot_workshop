extends KinematicBody2D

export (int) var speed = 200

var direction = Vector2()

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()