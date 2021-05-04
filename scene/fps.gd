extends Spatial


# Declare member variables here. Examples:
# var a = 2
onready var label = $Control/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text=str(Engine.get_frames_per_second())
