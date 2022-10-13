extends KinematicBody2D

export (int) var speed = 300
export (int) var dest_y = 300

var _state = 0
var _parent
var _dest
var _retreat_angle

onready var _wait_timer = $WaitTimer
onready var _shoot_manager = $ShootManager

func _ready():
	dest_y = dest_y + Globals.rng.randf_range(-20, 20)
	_parent = get_parent()
	_dest = Vector2(get_global_position().x, dest_y)

func _physics_process(delta):
	if not _parent.is_dead:
		var pos = get_global_position()
		match _state:
			0:
				set_global_position(lerp(pos, _dest, 0.03))
				var offset = pos.y - dest_y
				if offset < 100 and offset > -100:
					_parent.can_shoot = true
					_parent.is_invul = false
				if offset < 10 and offset > -10:
					_state = 1
					_wait_timer.start()
			2:
				if not _shoot_manager.is_shooting:
					_parent.can_shoot = false
					_state = 3
					if get_global_position().x < get_viewport_rect().size.x / 2:
						_retreat_angle = deg2rad(250)
					else:
						_retreat_angle = deg2rad(290)
			3:
				rotation = lerp_angle(rotation, _retreat_angle - PI / 2, 0.1)
				var offset = rad2deg(rotation - _retreat_angle - PI / 2)
				if offset < 10 and offset > -10:
					_state = 4
		
		if _state < 2:
			move_and_slide(Globals.cam_velocity)
		else:
			var direction = Vector2(cos(_retreat_angle), sin(_retreat_angle))
			move_and_slide(direction * speed)
	else:
		move_and_slide(Globals.cam_velocity)

func _on_WaitTimer_timeout():
	_state = 2
