# Read Enemy1_BulletSpawner.gd for the basics.
extends Position2D

const Bullet = preload("res://src/actors/EnemyBullet.tscn")

func shoot():
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null:
		# Since we want to shoot 5 shots, we use a for loop to handle that
		# with minimal boilerplate code.
		# At the start, i = 0 and increases by 1 each time a loop is completed.
		# The loop stops when i = 5. Effectively, i will only take the values 0
		# to 4 within the for loop, since the code within the for loop is not
		# executed when i = 5.
		for i in 5:
			var bullet_instance = Bullet.instance()
			var pos = get_global_position()
			bullet_instance.global_position = pos
			bullet_instance.set_scale(Vector2(2,2))
			get_tree().get_root().add_child(bullet_instance)
			
			# Since the bullets aren't aimed at the player this time, the
			# direction of the bullet has to be done differently.
			# First, recall that the y-axis points downwards, so the middle
			# bullet (which goes straight down) should be using an angle of 90
			# degrees.
			# Next, the bullets are spawned from left to right, with an interval
			# of 20 degrees between each bullet. As such, the first bullet
			# uses an angle of 90 + 20 * 2 = 130 degrees, which we will use as
			# the basis for all 5 bullets.
			# From there, we can subtract 20 degrees on each loop by using the
			# value of i, so that the other bullets are spawned at 110, 90, 70
			# and 50 degrees.
			#
			# Angle calculations are done in radians, so we use the built-in
			# deg2rad function to convert the angle from degrees to radians.
			# You can also just calculate the angle in radians from the get-go
			# (PI is the built in variable that provides the value of pi).
			var angle = deg2rad(130 - 20 * i)
			# Converting the angle to a Vector2 can be simply done with a bit
			# of trigonometry. Cosine is used to track changes across the
			# horizontal axis, while sine is used for the vertical axis.
			# Since the value of cos(angle)^2 + sin(angle)^2 = 1, this vector
			# is by definition a unit vector, so we do not need to normalise it. 
			bullet_instance.direction = Vector2(cos(angle), sin(angle))
