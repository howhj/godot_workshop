extends KinematicBody2D

export (float) var speed = 200
var direction = Vector2()
var _can_bounce = true
var _please_leave = false

func _physics_process(delta):
	move_and_collide(direction * speed * delta)
	
	var player = get_node_or_null("/root/Level/Player")
	var viewport = get_viewport_rect().size
	var pos = get_global_position()
	var x_low = 8 * scale.x
	var x_high = viewport.x - x_low
	var y_low = 8 * scale.y
	var y_high = viewport.y - y_low
	
	if _can_bounce and not _please_leave:
		if pos.x <= x_low or pos.x >= x_high:
			direction.x = -direction.x
			_please_leave = true
			if player != null:
				var player_pos = player.get_global_position()
				if player_pos.y > pos.y and direction.y < 0:
					direction.y = -direction.y
				elif player_pos.y < pos.y and direction.y > 0:
					direction.y = -direction.y
		elif pos.y <= y_low or pos.y >= y_high:
			direction.y = -direction.y
			_please_leave = true
			if player != null:
				var player_pos = player.get_global_position()
				if player_pos.x > pos.x and direction.x < 0:
					direction.x = -direction.x
				elif player_pos.x < pos.x and direction.x > 0:
					direction.x = -direction.x
	
	if _please_leave and pos.x > x_low and pos.x < x_high and pos.y > y_low and pos.y < y_high:
		_please_leave = false


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Timer_timeout():
	_can_bounce = false
