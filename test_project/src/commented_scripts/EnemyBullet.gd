# This is pretty similar to Player_bullet.gd.
extends KinematicBody2D

export (int) var speed = 200

# This is the main difference. In order to set the direction the enemy bullet
# will move in, we need to create a variable which can be accessed by other
# scripts.
var direction = Vector2()

func _physics_process(delta):
	# And we use the direction variable here to modify its trajectory.
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
