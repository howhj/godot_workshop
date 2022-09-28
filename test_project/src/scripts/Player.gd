# Nodes have built-in functionality to them, which can be accessed by using
# the extends keyword.
extends KinematicBody2D

# The export keyword allows the variable to be edited through the inspector.
# (int) forces the input field in the inspector to only accept integer values.
# The value set using the inspector will override the value defined here.
export (int) var speed = 300

# This loads the player bullet scene, so that we can instantiate it later.
# We set it as a constant instead of a variable, since we won't be editing it
# in the code later.
const Bullet = preload("res://src/actors/Player_bullet.tscn")
# The next few variables are used to regulate how often the player shoots.
# fire_rate represents the number of shots per second.
#
# Historically, the maximum fire rate is 30Hz, since games used to only shoot
# a single bullet every time a button is pressed (holding it will not shoot
# additional shots). This means that the game has to check if the button is
# released on the next frame. Thus, the maximum number of button presses is 30
# per second (since in-game logic ran at 60Hz back then too).
#
# In Japan, autofire is usually enabled on a separate button to circumvent this,
# allowing you to hold down a button to rapidly fire. In this workshop, we
# make autofire the default instead of button mashing.
#
# There's no such limitation in Godot here, so you are also able to set the
# fire rate up to 60Hz, since that is the frequency that the game logic is
# running in.
export (int) var fire_rate = 15
# _current_frame and _max_frames are used to count the frames between shots.
# When _current_frame reaches _max_frames, a shot is fired and _current_frame
# is reset to 0.
#
# An underscore before the variable name is used to indicate that the variable
# should be private i.e. it should not be accessed from an external script.
# This is just a good coding practice to have, since GDscript does not have
# public and private variables like Java or C#.
# If you really wanted to, you could still modify the below variables from
# another script.
var _current_frame = 0
var _max_frames

# _ready() is a built-function that is called when the object is loaded in the
# current scene.
func _ready():
	# Here, we set the value for _max_frames. This has to be done here instead
	# of when we declare the _max_frames variable above, since Godot only
	# fetches the value specified in the inspector when the object is loaded.
	# If we put this line in the variable declaration, it would use the hard
	# coded value of 15 instead, no matter what value is specified in the
	# inspector.
	_max_frames = 60 / fire_rate

# _physics_process() is a built-in function. It loops 60 times a second, using
# regular intervals. This means that even if the framerate is not stable,
# _physics_process() will run at a stable 60Hz, so any game logic put here will
# not speed up or slow down with the framerate.
#
# delta represents the time in seconds between frames.
func _physics_process(delta):
	# The first part deals with the player movement.
	# We first try to get the direction from player inputs.
	
	# Input.get_action_strength() returns a value ranging from 0 to 1.
	# Since the x-axis points to the right, rightward movement should be
	# positive while leftward movement should be negative.
	var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# Meanwhile, the y-axis points down, so downward movement is positive while
	# upward movement is negative.
	var vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# We create a Vector2 with the values we obtained. We also normalise the
	# result to create a unit vector. This is to ensure that diagonal movement
	# covers the same distance as horizontal or vertical movement. Without
	# normalisation, diagonal movement would be sqrt(2) times as long as
	# horizontal or vertical movement.
	var direction = Vector2(horizontal, vertical).normalized()
	
	# Now, we simply multiply the unit vector with a scalar (speed) to get
	# our velocity.
	var velocity = direction * speed
	
	# move_and_slide() is a built-in function of KinematicBody2D. It causes
	# the object to move at the velocity provided to it, and if it collides
	# with something, it will try to slide off of it instead of coming to a
	# full stop.
	move_and_slide(velocity)
	
	# This part deals with shooting projectiles.
	if Input.get_action_strength("shoot") > 0:
		# We check that _current_frame has the correct value before we allow
		# a bullet to be fired off.
		if _current_frame == 0:
			# This creates an instance of the player bullet scene we have loaded
			# earlier.
			var bullet_instance = Bullet.instance()
			
			# Here, we set where the bullet instance should be created. We want
			# to spawn it where the Bullet_spawner is. In order to have a common
			# reference frame, using global position is required.
			bullet_instance.global_position = $Bullet_spawner.get_global_position()
			
			# This is to simply scale up the size of the bullet instance.
			bullet_instance.set_scale(Vector2(2,2))
			
			# get_tree() is used to access the list of nodes in the current
			# scene.
			# get_root() is used to access the root node. When the player is
			# placed in a level, the root node will be Node2D.
			# add_child() will make the bullet instance a child of the node
			# being referenced.
			#
			# Together, these are used to make the bullet instance a child of
			# Node2D, instead of the player. Child nodes will follow any
			# movement made by the parent, so we want to ensure that the player
			# does not affect the movement of the bullet instance after the
			# bullet has been fired. To do this, we make the bullet instance a
			# child of Node2D instead, which is an immobile object.
			get_tree().get_root().add_child(bullet_instance)
		
		# This is used to increment the value of _current_frame.
		# The modulus operator (%) takes the remainder of the division, which
		# is a handy way to limit the values that _current_frame can take to
		# 0 <= _current_frame < _max_frames.
		_current_frame = (_current_frame + 1) % _max_frames
	
# This basically destroys the player when it collides with an enemy or an enemy
# bullet. See Enemy.gd for more details on how the built-in function works.
func _on_Hitbox_body_entered(body):
	queue_free()
