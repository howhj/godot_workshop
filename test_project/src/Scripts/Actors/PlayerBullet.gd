extends KinematicBody2D

export (int) var speed = 1000

var direction = Vector2()

func _physics_process(delta):
	move_and_collide(direction * speed * delta)
		
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
