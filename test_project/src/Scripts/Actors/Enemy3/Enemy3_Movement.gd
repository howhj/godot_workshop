extends KinematicBody2D

export (int) var speed = 300
export (int) var dest_y = 512

var _hover_dest = [Vector2(384, 512), Vector2(334, 462), Vector2(334, 562), Vector2(434, 462), Vector2(434, 562)]
var _next_dest
var _state = 0
var _parent

onready var _wait_timer = $WaitTimer
onready var _hitbox = $Hitbox

func _ready():
	_parent = get_parent()

func _physics_process(delta):
	if not _parent.is_dead:
		var pos = get_global_position()
		match _state:
			0:
				var dest = Vector2(pos.x, dest_y)
				set_global_position(lerp(pos, dest, 0.05))
				var offset = pos.y - dest_y
				if offset < 100 and offset > -100:
					_parent.can_shoot = true
					_parent.is_invul = false
				if offset < 10 and offset > -10:
					_state = 1
					_wait_timer.start()
			1:
				_next_dest = _hover_dest[Globals.rng.randf_range(0, _hover_dest.size())]
				_state = 2
			2:
				set_global_position(lerp(pos, _next_dest, 0.01))
				if (_next_dest - pos).length() < 5:
					_state = 1
			3:
				move_and_slide(Vector2(0, -speed))
	else:
		move_and_slide(Globals.cam_velocity)

func _on_WaitTimer_timeout():
	_state = 3
	_parent.can_shoot = false
	_parent.is_invul = true
