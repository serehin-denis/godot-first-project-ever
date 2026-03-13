extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -650.0
const GRAVITY_MULTIPIER = 1.2
const AIR_ACCEL = 30.0
const DEF_ACCEL = 45
const WALL_SLIDE_SPEED = 100
const WALL_UP_FRICTION = 700
@export var show_vel: Label
@export var jump_height : float = 225.0 
@export var jump_time_to_peak : float = .55


@onready var jump_velocity : float = -((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity : float = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)

# animations control
func flip_img(direction):
	if direction > 0: $AnimatedSprite2D.scale.x = 1
	elif direction < 0: $AnimatedSprite2D.scale.x = -1
	
func change_animation():
	if is_on_floor(): 
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if $RayCastRight.is_colliding() or $RayCastLeft.is_colliding() :
			$AnimatedSprite2D.play("wall_slide")
		else:
			if velocity.y >= 0:
				$AnimatedSprite2D.play("fall")
			else:
				$AnimatedSprite2D.play("jump")

# movement
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: velocity.y += jump_gravity * delta * GRAVITY_MULTIPIER
		else: velocity.y += jump_gravity * delta
		if $RayCastRight.is_colliding() or $RayCastLeft.is_colliding() : 
			if velocity.y >= 0 : velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
			else : velocity.y = move_toward(velocity.y, 0, WALL_UP_FRICTION * delta)

	# Handle jump.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif $RayCastRight.is_colliding() or $RayCastLeft.is_colliding():
			velocity.y = jump_velocity * .8
			velocity.x += 400 * direction * -1
	if Input.is_action_just_released("ui_accept") and velocity.y < 0: velocity.y /= 2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

		
	#if direction:
	#	if is_on_floor():
	#		velocity.x = direction * SPEED
	#	else:
	#		if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
	#			velocity.x = move_toward(velocity.x, direction * SPEED, 15)
	#		else:
	#			velocity.x = direction * SPEED
	#		
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor():
		velocity.x = move_toward(velocity.x, direction * SPEED, DEF_ACCEL) if direction else move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, direction * SPEED, AIR_ACCEL)
		

	move_and_slide()
	flip_img(velocity.x)
	change_animation()
	show_vel.text = str(velocity.y)
