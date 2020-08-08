extends Skeleton


func _ready():
	physical_bones_start_simulation()

func _process(delta):
	$"Physical Bone Bone".apply_central_impulse(Vector3.UP*0.4*60*delta)
