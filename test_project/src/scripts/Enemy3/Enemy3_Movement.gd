extends KinematicBody2D

var _state = 0
export var dest = Vector2(359, 512)
export (float) var lerp_weight = 0.05
var _rng
export var hover_dest = [Vector2(359, 512), Vector2(309, 462), Vector2(309, 562),
						Vector2(409, 462), Vector2(409, 562)]
var _next_dest = Vector2()

func _ready():
	_rng = RandomNumberGenerator.new()
	_rng.randomize()

func _physics_process(delta):
	var pos = get_global_position()
	match _state:
		0:
			move(dest, lerp_weight)
			
			var offset = (pos - dest).length()
			if offset > -50 and offset < 50:
				$Node2D.can_shoot = true
			if offset > -5 and offset < 5:
				_state = 1
				$WaitTimer.start()
	
		1:
			_next_dest = hover_dest[_rng.randf_range(0, hover_dest.size())]
			_state = 2
	
		2:
			move(_next_dest, lerp_weight/5)
			var offset = (pos - _next_dest).length()
			if offset > -5 and offset < 5:
				_state = 1
	
		3:
			move(Vector2(pos.x, -500), lerp_weight/5)


func _on_WaitTimer_timeout():
	_state = 3
	$Node2D.can_shoot = false
	
func move(dest, lerp_weight):
	var pos = get_global_position()
	pos = lerp(pos, dest, lerp_weight)
	set_global_position(pos)
