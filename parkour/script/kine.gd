extends KinematicBody

var x=0
var y=0
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up") :
		x=1
	elif Input.is_action_pressed("ui_down"):
		x=-1
	else:
		x=0
	if Input.is_action_pressed("ui_left") :
		y=1
	elif Input.is_action_pressed("ui_right") :
		y=-1
	else:
		y=0
	move_and_slide(Vector3(-y,0,-x)*5)
