extends RigidBody

var isonhand=false
var canrelease=true
onready var bullet=preload("res://scene/bullet.tscn")
onready var gunpoint=$Cube/gunpoint
onready var pl=get_node("/root/Spatial/player")
var shooted=false

func _physics_process(delta):
	if isonhand:
		gunpoint.look_at(pl.gunpp,Vector3.UP)

func _process(delta):
	if isonhand:
		if shooted:
			if not $AnimationPlayer.is_playing():
				shooted=false
				canrelease=true
			
		if Input.is_action_just_pressed("graple") and not shooted:
			var b=bullet.instance()
			var temp=gunpoint.get_global_transform().basis.z
			var t=gunpoint.get_global_transform()
			get_node("/root/Spatial").add_child(b)
			b.set_global_transform(t)
			b.scale=Vector3(1,1,1)
			b.apply_central_impulse(-temp*90)
			$Cube/gunpoint/Particles.emitting=true
			shooted=true
			$AnimationPlayer.play("recoil")
			canrelease=false
	
