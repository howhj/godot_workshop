extends Position2D

const Bullet = preload("res://src/actors/EnemyBullet.tscn")

func shoot():
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	var pos = get_global_position()
	
	if player != null and (pos - player.get_global_position()).length() > 200:
		var bullet_instance = Bullet.instance()
		bullet_instance.global_position = pos
		bullet_instance.set_scale(Vector2(2,2))
		get_tree().get_root().add_child(bullet_instance)
		
		var player_pos = player.get_global_position()
		var direction = player_pos - pos
		bullet_instance.direction = direction.normalized()
