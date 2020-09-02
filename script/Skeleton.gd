extends Skeleton

onready var head=$"Physical Bone Bone"

func _ready():
	physical_bones_start_simulation()

func _process(delta):
	if head:
		head.apply_central_impulse(Vector3.UP*0.4*60*delta)
