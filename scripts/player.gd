extends CharacterBody2D

# Player Paramaters
@export_group("Player Movement Settings")
@export var max_speed := 80.0
@export var acceleration := 100.0
@export var friction := 100.0

@export_group("Player Jump Settings")
@export var jump_velocity := -200.0
@export var jump_buffer_time := 0.1
@export var coyote_time := 0.2


# Node References
@onready var animation := $AnimatedSprite2D


 #Variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor := true
var jump_count := 0
var is_jump_buffer_active := false


func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		apply_gravity(delta)
	else:
		was_on_floor = true
		jump_count = 0

	handle_coyote_time()
	handle_movement()
	handle_jump()
	handle_platform_drop()

	move_and_slide()


func handle_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	handle_direction(direction)
	if direction:
		if is_on_floor(): animation.play("walk")
		velocity.x = move_toward(velocity.x, max_speed* direction, acceleration)
	else:
		if is_on_floor(): animation.play("idle")
		velocity.x = move_toward(velocity.x, 0, friction)


func apply_gravity(delta) -> void:
	velocity.y += gravity * delta


func handle_jump() -> void:
	# Bad code - fix later
	if Input.is_action_just_pressed("jump") and jump_count < 1:
		if is_on_floor() or was_on_floor:
			jump()
	elif Input.is_action_just_pressed("jump"):
		if not is_on_floor() or not was_on_floor:
			start_jump_buffer()
	if is_jump_buffer_active and is_on_floor():
		jump()
		is_jump_buffer_active = false


func jump() -> void:
	jump_count += 1
	animation.play("jump")
	velocity.y = jump_velocity


func handle_direction(direction) -> void:
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false


func start_jump_buffer() -> void:
	is_jump_buffer_active = true
	get_tree().create_timer(jump_buffer_time).timeout.connect(func(): is_jump_buffer_active = false)


func handle_coyote_time() -> void:
	if not is_on_floor() && was_on_floor:
		get_tree().create_timer(coyote_time).timeout.connect(func(): was_on_floor = false)


func handle_platform_drop() -> void:
	if Input.is_action_pressed("down") && is_on_floor():
		position.y += 1
