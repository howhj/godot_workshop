# I will skip over anything that has been mentioned in Player.gd.
extends KinematicBody2D

export var speed = 1000

func _physics_process(delta):
	# We only require our bullet to travel upward, so we can define the
	# velocity in a much simpler fashion.
	var velocity = Vector2(0, -speed)
	
	# move_and_collide() is another built-in function of KinematicBody2D.
	# Unlike move_and_slide(), this will stop all movement once the object
	# collides with something.
	#
	# move_and_collide() returns a boolean that represents whether a collision
	# happened.
	#
	# We multiply the velocity with delta to ensure that the bullet doesn't
	# move too quickly.
	var collision = move_and_collide(velocity * delta)
	
	# queue_free() deletes the current object. So, if the bullet collides with
	# something, we want to remove it.
	if collision:
		queue_free()
