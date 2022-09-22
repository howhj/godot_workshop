extends Position2D

const Bullet = preload("res://src/actors/EnemyBullet.tscn")

func shoot_flower():
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null:
		for i in 5:
			var bullet_instance = Bullet.instance()
			var pos = get_global_position()
			bullet_instance.global_position = pos
			bullet_instance.set_scale(Vector2(4,4))
			get_tree().get_root().add_child(bullet_instance)
			
			var player_pos = player.get_global_position()
			var direction = player_pos - pos
			var angle = rad2deg(direction.angle())
			angle = deg2rad(angle + 72 * i)
			bullet_instance.direction = Vector2(cos(angle), sin(angle))
			bullet_instance.speed = 300
		
		for i in 5:
			var bullet_instance = Bullet.instance()
			var pos = get_global_position()
			bullet_instance.global_position = pos
			bullet_instance.set_scale(Vector2(4,4))
			get_tree().get_root().add_child(bullet_instance)
			
			var player_pos = player.get_global_position()
			var direction = player_pos - pos
			var angle = rad2deg(direction.angle())
			angle = deg2rad(angle + 72 * i + 36)
			bullet_instance.direction = Vector2(cos(angle), sin(angle))
			
		for i in 10:
			var bullet_instance = Bullet.instance()
			var pos = get_global_position()
			bullet_instance.global_position = pos
			bullet_instance.set_scale(Vector2(4,4))
			get_tree().get_root().add_child(bullet_instance)
			
			var player_pos = player.get_global_position()
			var direction = player_pos - pos
			var angle = rad2deg(direction.angle())
			angle = deg2rad(angle + 36 * i + 54)
			bullet_instance.direction = Vector2(cos(angle), sin(angle))
			bullet_instance.speed = 250

func shoot_lines(offset):
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null:
		for i in 5:
			var bullet_instance = Bullet.instance()
			var pos = get_global_position()
			bullet_instance.global_position = pos
			bullet_instance.set_scale(Vector2(2,2))
			get_tree().get_root().add_child(bullet_instance)
			
			var angle = deg2rad(270 + 72 * i + offset)
			bullet_instance.direction = Vector2(cos(angle), sin(angle))
