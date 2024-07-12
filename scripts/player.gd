extends CharacterBody2D

@export var max_speed= 80.0
@export var jump_velocity = -200.0
@export var acceleration = 100.0
@export var friction = 100.0

@onready var animation = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		apply_gravity(delta)
	
	handle_movement()
	handle_jump()

	move_and_slide()

func handle_movement():
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	handle_direction(direction)
	if direction:
		if is_on_floor(): animation.play("walk")
		velocity.x = move_toward(velocity.x, max_speed* direction, acceleration)
	else:
		if is_on_floor(): animation.play("idle")
		velocity.x = move_toward(velocity.x, 0, friction)

func apply_gravity(delta):
	velocity.y += gravity * delta

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animation.play("jump")
		velocity.y = jump_velocity

func handle_direction(direction):
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false
