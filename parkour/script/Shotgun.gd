extends RigidBody

var isonhand=false
var canrelease=true
onready var bullet=preload("res://scene/bullet.tscn")
onready var gunpoint=$Cube/gunpoint
onready var pl=get_node("/root/Spatial/player")
var shooted=false
var time=0

func _physics_process(delta):
	if isonhand:
		gunpoint.look_at(pl.gunpp,Vector3.UP)

func _process(delta):
	if isonhand:
		if shooted:
			time+=delta
			if time<=0.3:
				rotate_x(-30*delta)
			if time>0.3:
				rotate_x(30*delta)
			if time>0.6:
				shooted=false
				canrelease=true
			
		if Input.is_action_just_pressed("graple"):
			var b=bullet.instance()
			var temp=gunpoint.get_global_transform().basis.z
			var t=gunpoint.get_global_transform()
			get_node("/root/Spatial").add_child(b)
			b.set_global_transform(t)
			b.scale=Vector3(1,1,1)
			b.apply_central_impulse(-temp*90)
			$Cube/gunpoint/Particles.emitting=true
			shooted=true
			canrelease=false
