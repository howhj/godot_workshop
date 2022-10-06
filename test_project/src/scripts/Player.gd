extends KinematicBody2D

export (int) var speed = 300

export (int) var lives = 3
var is_dead = false
var _is_invul = false
export var spawn_location = Vector2(359, 950)

const Bullet = preload("res://src/actors/Player_bullet.tscn")

export (int) var fire_rate = 15
var _current_frame = 0
var _max_frames

func _ready():
	_max_frames = 60 / fire_rate
	var scale_value = get_parent().scale_value
	set_scale(Vector2(scale_value, scale_value))
	set_global_position(spawn_location)

func _physics_process(delta):
	if is_visible():
		var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		var direction = Vector2(horizontal, vertical).normalized()
		move_and_slide(direction * speed)
		
		var x_offset = 8 * scale.x
		var y_offset = 12 * scale.y
		var viewport = get_viewport_rect().size
		var pos = get_global_position()
		pos.x = clamp(pos.x, x_offset, viewport.x - x_offset)
		pos.y = clamp(pos.y, y_offset, viewport.y - y_offset)
		set_global_position(pos)
		
		if Input.get_action_strength("shoot") > 0:
			if _current_frame == 0:
				var bullet_instance = Bullet.instance()
				bullet_instance.global_position = $Bullet_spawner.get_global_position()
				bullet_instance.set_scale(Vector2(2,2))
				get_tree().get_root().add_child(bullet_instance)
			_current_frame = (_current_frame + 1) % _max_frames
	
func _on_Hitbox_body_entered(body):
	if not _is_invul:
		lives -= 1
		is_dead = true
		_is_invul = true
		hide()
		if lives > 0:
			$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	if not is_visible():
		$RespawnTimer.start()
		show()
		set_global_position(spawn_location)
	else:
		is_dead = false
		$InvulTimer.start()

func _on_InvulTimer_timeout():
	_is_invul = false
