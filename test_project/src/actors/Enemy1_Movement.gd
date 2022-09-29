extends KinematicBody2D

export (int) var speed = 300
export (int) var dest_y = 300
var _state = 0
var _retreat_angle

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	dest_y = dest_y + rng.randf_range(-20, 20)
	$Node2D.can_shoot = false

func _physics_process(delta):
	var pos = get_global_position()
	
	if _state == 0:
		var dest = Vector2(pos.x, dest_y)
		set_global_position(lerp(pos, dest, 0.03))
		var offset = pos.y - dest_y
		
		if offset < 100 and offset > -100:
			$Node2D.can_shoot = true
		if offset < 10 and offset > -10:
			_state = 1
			$WaitTimer.start()
	
	if _state == 2:
		rotation = lerp_angle(rotation, _retreat_angle, 0.1)
		var offset = rad2deg(rotation - _retreat_angle)
		if offset < 0.1 and offset > -0.1:
			_state = 3
	
	if _state > 1:
		var direction = Vector2(cos(_retreat_angle + PI/2), sin(_retreat_angle + PI/2))
		move_and_slide(direction * speed)

func _on_WaitTimer_timeout():
	_state = 2
	$Node2D.can_shoot = false
	if get_global_position().x < 300:
		_retreat_angle = deg2rad(250) - PI/2
	else:
		_retreat_angle = deg2rad(290) - PI/2
