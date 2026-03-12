extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -650.0
const GRAVITY_MULTIPIER = 2
const AIR_ACCEL = 30.0
const DEF_ACCEL = 45
@export var show_vel: Label

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
		if velocity.y >= 0:
			$AnimatedSprite2D.play("fall")
		else:
			$AnimatedSprite2D.play("jump")

# movement
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: velocity += get_gravity() * delta * GRAVITY_MULTIPIER
		else: velocity += get_gravity() * delta
		

	# Handle jump.

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("ui_accept") and velocity.y < 0: velocity.y /= 2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
		
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
	show_vel.text = "velpcity.x: %s, velocity.y: %s" % [velocity.x, velocity.y]
