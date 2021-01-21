extends RigidBody


func _ready():
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
		$CollisionShape.disabled=true


func _on_Area_body_entered(body):
	del=true
	$MeshInstance.visible=false
	$Position3D/Trail3D.visible=false
	$Particles.set_as_toplevel(true)
	$Particles.emitting=true



func _on_Timer_timeout():
	queue_free()
