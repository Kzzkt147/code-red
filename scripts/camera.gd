extends Camera2D

@export var target : Node2D

const CAMERA_WIDTH := 230

var next_slide_x_value := 0
var previous_slide_x_value := 0


func _ready():
	next_slide_x_value = CAMERA_WIDTH


func _process(_delta):
	if target.global_position.x > next_slide_x_value:
		next_slide_x_value += CAMERA_WIDTH
		previous_slide_x_value += CAMERA_WIDTH
		global_position.x += CAMERA_WIDTH
	elif target.global_position.x < previous_slide_x_value:
		next_slide_x_value -= CAMERA_WIDTH
		previous_slide_x_value -= CAMERA_WIDTH
		global_position.x -= CAMERA_WIDTH
