extends ImmediateGeometry

var points = 50
var time = 0
var leng=0.03
var loc
var to
var up
var firstup

onready var cam=get_node("/root/Spatial/player/head/neck/Camera")

func _ready():
	pass
	#Reset()

func Reset():
	points=50
	time=0
	clear()
	get_parent().get_child(4).clear()

func Update(delta):
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	to=to_local(get_parent().grapple_Point)
	up=to_local(get_parent().grapple_Point).normalized().cross(to_local(cam.get_global_transform().origin)).normalized()
	firstup=up
	set_color(Color(0,0,0))
	add_vertex(Vector3()+up*leng)
	add_vertex(Vector3()-up*leng )
	if time<0.3:
		time += delta
	else:
		time=0.3
	if time<0.15:
		to*=time/0.15
	for i in range(0,points):
		loc=to* (float(i+1)/points)+(1-float(i+1)/points)*(1-time/0.3)*firstup*0.3*sin((float(i)/points)*float(int(to.length()/2))*PI+(1-time/0.3)*15)
		up=loc.normalized().cross(to_local(cam.get_global_transform().origin)).normalized()
		if i==49:
			up=Vector3()
		add_vertex(loc +up*leng)
		add_vertex(loc-up*leng)
	end()
	get_parent().get_child(4).shadowdraw(loc)
