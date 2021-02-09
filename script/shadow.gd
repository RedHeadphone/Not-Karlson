extends ImmediateGeometry

func _ready():
	pass

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
