# This is used for the first pattern (aimed 3 shots from left and right).
#
# The code is actually identical to Enemy1_BulletSpawner.gd.
# Still, making them separate scripts makes it easier to manage, and you can
# further customise the behaviour of one enemy without affecting the other(s).
# For example, on a higher difficulty setting, you want Enemy1 to shoot 3-way
# shots instead of a single shot, but you do not want Enemy2 to have that same
# behaviour.
extends Position2D

const Bullet = preload("res://src/actors/EnemyBullet.tscn")

func shoot():
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null:
		var bullet_instance = Bullet.instance()
		var pos = get_global_position()
		bullet_instance.global_position = pos
		bullet_instance.set_scale(Vector2(2,2))
		get_tree().get_root().add_child(bullet_instance)
		
		var player_pos = player.get_global_position()
		var direction = player_pos - pos
		bullet_instance.direction = direction.normalized()
