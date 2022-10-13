extends Position2D

const Bullet = preload("res://src/Actors/Enemy_bullet.tscn")
	
func _shoot():
	var player = get_node_or_null("/root/Level/High_priority/Player")
	if player != null and not player.is_dead:
		var instance = Bullet.instance()
		var pos = get_global_position()
		instance.global_position = pos
		instance.set_scale(get_node("../../..").scale)
		get_node("/root/Level/Low_priority").add_child(instance)
		
		var player_pos = player.get_global_position()
		instance.direction = (player_pos - pos).normalized()

func _on_Timer_timeout():
	_shoot()
