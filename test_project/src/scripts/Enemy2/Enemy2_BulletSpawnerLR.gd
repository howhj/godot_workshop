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
