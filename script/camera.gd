extends Camera

export var campath :NodePath

onready var cam=get_node(campath)


func _ready():
	var save_game = File.new()
	if not save_game.file_exists("user://resol.save"):
		print("oop")
	save_game.open("user://resol.save", File.READ)
	var ob=parse_json(save_game.get_line())
	
	save_game.close()
	if ob==null:
		return
	get_parent().size=Vector2(int(ob["resx"]),int(ob["resy"]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform=cam.get_global_transform()
