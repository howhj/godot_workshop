# Read Enemy1_BulletSpawner.gd and Enemy2_BulletSpawnerM.gd for pre-requisite
# information.
extends Position2D

const Bullet = preload("res://src/actors/EnemyBullet.tscn")
var _scale_value

func _ready():
	_scale_value = get_node("../../..").scale.x
	print(_scale_value)

# Since a lot of bullets are being created, we make it into a function to
# greatly reduce boilerplate code.
#
# Setting speed=200 in the parameters means that speed has a default value of
# 200. If a speed value is not provided when calling this function, the default
# value is used. If a speed value is provided, it overrides the default value.
# Otherwise, this is pretty much the same as with other enemies.
func _create_bullet(pos, scale_val, angle, speed=200):
	var bullet_instance = Bullet.instance()
	bullet_instance.global_position = pos
	bullet_instance.set_scale(Vector2(scale_val, scale_val))
	get_tree().get_root().add_child(bullet_instance)
	bullet_instance.direction = Vector2(cos(angle), sin(angle))
	bullet_instance.speed = speed

# This is used to create the flower-shaped burst.
# The flower will have 5 petals, so correspondingly, there will be 5 bullets to
# represent the 5 petal tips.
#
# Then, there will be 5 points connecting adjacent petals, which will be called
# the base. The base will be the angular bisector of the 2 adjacent tips.
#
# Finally, a bullet is used to connect each tip with each base, which will be
# called the mid. The mid will be the angular bisector of the tip and the base.
# Since there are 5 bases and 5 tips, 10 mids will be required.
#
# In total, we will use 20 bullets for the flower.
func shoot_flower():
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null and not player.get_parent().is_dead:
		# Like the 5-way shot in Enemy2_BulletSpawnerM.gd, we use a for loop to
		# create the 5 petals with minimal boilerplate code.
		# Since there are 20 bullets in total, we will create 4 bullets per loop.
		# Each loop will spawn a tip, a mid, a base and finally another mid.
		for i in 5:
			# These are common values used by all 4 bullets.
			var pos = get_global_position()
			var player_pos = player.get_global_position()
			var direction = player_pos - pos
			# The pattern is aimed at the player, so we need the angle from
			# the BulletSpawner to the player. However, since we also need to
			# add an angular offset for each petal, we retrieve the angle from
			# the direction Vector2 using the angle() method.
			# The interval between petal tips is simply 360 / 5 = 72.
			var base_angle = rad2deg(direction.angle()) + 72 * i
			
			# This creates the petal tip. Its speed is increased to 300 to make
			# it travel further than the mids and bases.
			var angle = deg2rad(base_angle)
			_create_bullet(pos, _scale_value, angle, 300)
			
			# This creates the first mid. The angular offset between any 2
			# bullets in this pattern is 360 / 20 = 18 degrees.
			# The speed is increased to 250 so that mids travel further than
			# bases, but not as far as tips.
			angle = deg2rad(base_angle + 18)
			_create_bullet(pos, _scale_value, angle, 250)
			
			# This creates the base.
			angle = deg2rad(base_angle + 36)
			_create_bullet(pos, _scale_value, angle)
			
			# This creates the second mid, which connects the mid to the next
			# tip (which is created on the next loop).
			angle = deg2rad(base_angle + 54)
			_create_bullet(pos, _scale_value, angle, 250)

# This is used to create the 5 continuous streams.
func shoot_lines(offset):
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null and not player.get_parent().is_dead:
		for i in 5:
			var pos = get_global_position()
			# Since the player is most likely going to be below the enemy, we
			# want to give the player as much space as possible when this enemy
			# first appears, in order to telegraph the pattern.
			#
			# As such, we use 270 degrees as the base angle, which means the
			# first stream will initially point straight up.
			#
			# As with the flower petals, the interval between streams is 72
			# degrees. We also add the angular offset as controlled by the
			# Manager.
			var angle = deg2rad(270 + 72 * i + offset)
			_create_bullet(pos, _scale_value/2, angle)

