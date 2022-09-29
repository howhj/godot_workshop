extends Sprite

var scroll_velocity

func _ready():
	var level = get_node_or_null("/root/Node2D")
	if level != null:
		scroll_velocity = level.scroll_velocity

func _physics_process(delta):
	translate(scroll_velocity * delta)
	var pos = get_global_position()
	if pos.y >= get_viewport_rect().size.y:
		set_global_position(Vector2(pos.x, pos.y - 3648))
