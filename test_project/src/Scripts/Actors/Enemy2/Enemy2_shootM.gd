extends Position2D

const Bullet = preload("res://src/Actors/Enemy_bullet.tscn")

func shoot():
	var player = get_node_or_null("/root/Level/High_priority/Player")
	if player != null and not player.is_dead:
		for i in 5:
			var instance = Bullet.instance()
			instance.global_position = get_global_position()
			instance.set_scale(get_node("../../..").scale)
			get_node("/root/Level/Low_priority").add_child(instance)
			
			var angle = deg2rad(50 + i * 20)
			instance.direction = Vector2(cos(angle), sin(angle))
