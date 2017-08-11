extends KinematicBody2D

var sprite_node

# -1 for going left, 1 for going right
var input_direction = 0
var direction = 1

var speed_x = 0
var speed_y = 0
var velocity = Vector2()
var jump_count = 0

const MAX_SPEED_X = 700
const JUMP_FORCE = 800
const GRAVITY = 2000
const ACCELERATION = 2000
const DECELERATION = 5000
const MAX_JUMP_COUNT = 2
const MAX_FALL_SPEED = 1400

func _ready():
	set_process(true)
	set_process_input(true)
	sprite_node = get_node("Sprite")

func _input(event):
	if event.is_action_pressed("jump"):
		if jump_count <= MAX_JUMP_COUNT - 1:
			speed_y = - JUMP_FORCE
			jump_count += 1
	

func _process(delta):
	# Move input
	var is_moving_left = Input.is_action_pressed("move_left")
	var is_moving_right = Input.is_action_pressed("move_right")
	# Input direction choice
	if is_moving_left:
		input_direction = -1
	elif is_moving_right:
		input_direction = 1
	elif not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		input_direction = 0
	# Changing direction
	if is_moving_left or is_moving_right and input_direction:
		if direction == -input_direction:
			speed_x /= 8
			direction = input_direction
			sprite_node.set_flip_h(!sprite_node.is_flipped_h())
	
	# Motion
	if input_direction:
		speed_x += ACCELERATION * delta
	else:
		speed_x -= DECELERATION * delta
	speed_x = clamp(speed_x, 0, MAX_SPEED_X)
	# Gravity
	speed_y += GRAVITY * delta
	if speed_y > MAX_FALL_SPEED:
		speed_y = MAX_FALL_SPEED
	# Move
	velocity.x = speed_x * delta * direction
	velocity.y = speed_y * delta
	var movement_remainder = move(velocity)
	
	# Manage ground collision
	if is_colliding():
		# Manage horizontal movement
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		# Manage vertical movement
		speed_y = normal.slide(Vector2(0, speed_y)).y
		# Reset jump count if colliding floor
		if normal == Vector2(0, -1):
			jump_count = 0
		# Execute movement
		move(final_movement)