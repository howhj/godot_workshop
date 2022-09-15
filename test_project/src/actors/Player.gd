extends KinematicBody2D

export var speed = 300
var bullet = preload("res://src/actors/Player_bullet.tscn")

func _physics_process(delta):
	var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var direction = Vector2(horizontal, vertical).normalized()
	var velocity = direction * speed
	move_and_slide(velocity)
	
	if Input.get_action_strength("shoot")> 0:
		var bullet_instance = bullet.instance()
		bullet_instance.global_position = $Bullet_spawner.get_global_position()
		bullet_instance.set_scale(Vector2(2,2))
		get_tree().get_root().add_child(bullet_instance)
	
