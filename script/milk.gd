extends Spatial


func _ready():
	pass # Replace with function body.

func _process(delta):
	var temp=rand_range(0,0.02)
	rotate_x(temp)
	rotate_y(0.02)
