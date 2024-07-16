extends Camera2D

@export var target : Node2D

@onready var camera_width : float = ProjectSettings.get_setting("display/window/size/viewport_width") / zoom.x
var next_slide_x_value := 0
var previous_slide_x_value := 0


func _ready():
	next_slide_x_value = camera_width


func _process(_delta):
	if target.global_position.x > next_slide_x_value:
		next_slide_x_value += camera_width
		previous_slide_x_value += camera_width
		global_position.x += camera_width
	elif target.global_position.x < previous_slide_x_value:
		next_slide_x_value -= camera_width
		previous_slide_x_value -= camera_width
		global_position.x -= camera_width
