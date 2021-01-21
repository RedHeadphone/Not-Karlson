extends Camera

export var campath :NodePath

onready var cam=get_node(campath)


func _ready():
	get_parent().size=Vector2(ProjectSettings["display/window/size/width"] ,ProjectSettings["display/window/size/height"] )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform=cam.get_global_transform()
