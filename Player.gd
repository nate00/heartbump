extends KinematicBody2D

signal died()

export (bool) var flip_flopper = false

const LATERAL_SPEED = 100.0

const DASH_SPEED = 1000.0
const DASH_DURATION = 0.05
var dash_remaining = 0.0
var dash_x_sign
var dash_is_charged = true

# We use *upward* velocity so we can use the same calculations no matter
# whether "up" is -1 or +1.
const MIN_UPWARD_VELOCITY = -256.0

const JUMP_UPWARD_VELOCITY = 250.0
const HEARTBEAT_UPWARD_VELOCITY = 350.0
var upward_velocity = 0.0
var gravity = -512.0
var up_is_flipped = false

var did_win := false
var did_die := false

const ROTATION_SPEED = PI/2  # radians per second

onready var sprite = $AnimatedSprite

func _physics_process(delta : float):
	if did_win or did_die:
		return
	
	if is_dashing():
		process_dash(delta)
	else:
		refresh_dash_charge()
		process_movement(delta)
	check_if_dead()

func process_movement(delta : float) -> void:
	var vector = Vector2.ZERO
	
	var x_sign : int = get_input_x_sign()
	if Input.is_action_just_pressed("dash") and dash_is_charged:
		dash_remaining = DASH_DURATION
		dash_x_sign = x_sign
		dash_is_charged = false
	else:
		vector += Vector2(x_sign, 0) * LATERAL_SPEED
		if x_sign != 0:
			sprite.flip_h = x_sign < 0
			# We multiply by (-1 * up_y_sign()) because:
			# - When up is up, leaning right is rotating clockwise
			# - When down is up, leaning right is rotating counterclockwise
			sprite.rotation += x_sign * delta * ROTATION_SPEED * (-1 * up_y_sign())
			sprite.rotation = clamp(sprite.rotation, -PI/8, PI/8)
	
	if x_sign == 0:
		if abs(sprite.rotation) < PI / 100:
			sprite.rotation = 0.0
		elif sprite.rotation < 0:
			sprite.rotation += delta*ROTATION_SPEED
		elif sprite.rotation > 0:
			sprite.rotation -= delta*ROTATION_SPEED
	
	if is_on_floor():
		upward_velocity = max(upward_velocity, 0.0)	# Kill the downward momentum, but keep just enough to continue detecting floor collisions
		print("on floor")
		if Input.is_action_just_pressed("jump"):
			upward_velocity = JUMP_UPWARD_VELOCITY
	if is_on_ceiling():
		# Bump head against ceiling, kill upward velocity
		upward_velocity = 0.0
	
	upward_velocity += gravity * delta
	upward_velocity = max(upward_velocity, MIN_UPWARD_VELOCITY)
	print(upward_velocity)
	vector += Vector2(0, up_y_sign()) * upward_velocity
	print(vector)
	
	move(vector)

func is_dashing() -> bool:
	return dash_remaining > 0.0

func process_dash(delta : float) -> void:
	upward_velocity = 0.0
	dash_remaining -= delta
	move(Vector2(dash_x_sign, 0) * DASH_SPEED)

func refresh_dash_charge() -> void:
	if is_on_floor():
		dash_is_charged = true

func move(vector : Vector2):
	move_and_slide(vector, Vector2(0, up_y_sign()))

func get_input_x_sign() -> int:
	var x_sign = 0
	if Input.is_action_pressed("left"):
		x_sign += -1
	if Input.is_action_pressed("right"):
		x_sign += 1
	return x_sign

func check_if_dead():
	if position.y > U.DISPLAY_HEIGHT + 200 or position.y < -200:
		die()

func on_heartbeat():
	if is_on_floor():
		print("is on floor")
		if flip_flopper:
			flip()
		else:
			upward_velocity = HEARTBEAT_UPWARD_VELOCITY


func flip():
	print("FLIP!!!")
	up_is_flipped = !up_is_flipped
	sprite.flip_v = !sprite.flip_v
	sprite.position.y = -sprite.position.y
	upward_velocity = -upward_velocity
	upward_velocity = -HEARTBEAT_UPWARD_VELOCITY
	
	# Jump 100 pixels off the ground. This jolts the player away from the
	# ground, and then they immediately decelerate to MIN_UPWARD_VELOCITY.
	# This deceleration feels nicer than accelerating or constant speed when
	# flipping gravity. Implementing that deceleration feeling via this 100px
	# jolt is a bit of a hack.
	move(Vector2(0, 100))

func up_y_sign():
	if up_is_flipped:
		return 1
	else:
		return -1

func on_heartbeat_end():
	pass

func take_damage():
	die()

func die():
	did_die = true
	emit_signal("died")

func on_won(trophy):
	self.global_position = trophy.global_position
	z_index = 2
	did_win = true
