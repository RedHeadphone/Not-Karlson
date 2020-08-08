extends RigidBody


func _ready():
#	var t=get_global_transform()
#	var tt=self
#	var tyt=get_parent().get_parent().get_parent()
#	get_parent().remove_child(self)
#	print(tyt.world)
#	tyt.world.add_child(tt)
#	self.set_global_transform(t)
	#set_as_toplevel(true)
	#self.scale=Vector3(1,1,1)
	pass

var del=false
var count=0
var to=false
var time=0

func _process(delta):
	if del:
		time+=delta
	if time>0.7:
		queue_free()


func _on_Area_body_entered(body):
	del=true
	$MeshInstance.visible=false
	$Position3D/Trail3D.visible=false
	$Particles.emitting=true
	$CollisionShape.disabled=true
	mode=RigidBody.MODE_STATIC

