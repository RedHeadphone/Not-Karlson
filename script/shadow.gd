extends ImmediateGeometry

#onready var sun=get_node("/root/Spatial/Sun")

func _ready():
	pass
	#sun=sun.get_global_transform().basis.z

func shadowdraw(loc):
	clear()
	begin(Mesh.PRIMITIVE_LINES)
	set_color(Color(0.29,0.078,0,0))
	set_normal(Vector3.UP)
	add_vertex(Vector3())
	set_color(Color(0.29,0.078,0,0))
	set_normal(Vector3.UP)
	add_vertex(loc)
	end()
