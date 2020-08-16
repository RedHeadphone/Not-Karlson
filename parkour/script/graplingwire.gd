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

func Reset():
	points=20
	time=0
	clear()
	get_parent().get_child(4).clear()

func Update(delta):
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	to=to_local(get_parent().grapple_Point)
	if time<0.3:
		time += delta
	else:
		time=0.3
	if time<0.15:
		to*=time/0.15
	up=to.normalized().cross(to_local(cam.get_global_transform().origin)).normalized()
	firstup=up
	set_color(Color(0,0,0))
	add_vertex(Vector3()+up*leng)
	add_vertex(Vector3()-up*leng )
	
	var temp=to_local(cam.get_global_transform().origin)
	for i in range(1,points):
		loc=to* (float(i)/points)+(1-float(i)/points)*(1-time/0.3)*firstup*0.3*sin((float(i)/points)*float(int(to.length()/3))*PI+(1-time/0.3)*15)
		up=loc.normalized().cross(temp).normalized()
		if i==19:
			up=Vector3()
		add_vertex(loc +up*leng)
		add_vertex(loc-up*leng)
	end()
	get_parent().get_child(4).shadowdraw(loc)
