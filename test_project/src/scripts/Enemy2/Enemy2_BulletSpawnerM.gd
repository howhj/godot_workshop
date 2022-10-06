# Read Enemy1_BulletSpawner.gd for the basics.
extends Position2D

const Bullet = preload("res://src/actors/EnemyBullet.tscn")

func shoot():
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null:
		for i in 5:
			var bullet_instance = Bullet.instance()
			var pos = get_global_position()
			bullet_instance.global_position = pos
			bullet_instance.set_scale(Vector2(2,2))
			get_tree().get_root().add_child(bullet_instance)
			
			var angle = deg2rad(130 - 20 * i)
			bullet_instance.direction = Vector2(cos(angle), sin(angle))
