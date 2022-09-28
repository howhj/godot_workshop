# Like the Manager, BulletSpawner scripts are unique to each enemy.
# This is pretty similar to how the player shoots.
extends Position2D

const Bullet = preload("res://src/actors/EnemyBullet.tscn")

func shoot():
	# get_node_or_null() is a built-in function to find a particular node by
	# providing the path to it in the current scene.
	#
	# The absolute path starts with /root. You can also use the relative path
	# from the current node (use .. to go up one level). For example, the
	# equivalent relative path used here would be ../../../Player/Hitbox.
	#
	# In contrast to get_node(), this returns a null result if the node cannot
	# be found, which is a safer way of handling things. get_node() would hang
	# if the node in question cannot be found.
	#
	# Here, we want to find the player's hitbox, so that bullets can be aimed
	# properly at the player. If you simply use the Player node, it aims at the
	# origin of the Player scene, which in this case is the bottom of the
	# sprite. So, unless you shift the player nodes so that Hitbox lies on the
	# origin, the bullets would be slightly inaccurate, and may miss the player
	# even though they are stationary.
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	
	# This check ensures that the enemy only shoots when the player exists.
	# Not only does this protect against unexpected behaviour or crashes when
	# the enemy has nothing to aim at, it also gives the player some respite
	# when they mess up and get hit, which helps them to recover when they
	# respawn.
	if player != null:
		# This part is the same as in Player.gd.
		var bullet_instance = Bullet.instance()
		var pos = get_global_position()
		bullet_instance.global_position = pos
		bullet_instance.set_scale(Vector2(2,2))
		get_tree().get_root().add_child(bullet_instance)
		
		# This handles how the enemy aims at the player. It simply does a bit
		# of vector math between the global positions of the BulletSpawner and
		# the player to acquire a unit vector that points towards the player,
		# then set it as the bullet's direction.
		var player_pos = player.get_global_position()
		var direction = player_pos - pos
		bullet_instance.direction = direction.normalized()
