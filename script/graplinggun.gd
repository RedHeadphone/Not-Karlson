extends RigidBody

enum{
	STATIC,
	RIGID,
	KINETIC
}

var body
var bodyitself

var isonhand:bool=false
var canrelease:bool=true
var grab:bool=false
onready var pointer=get_node("/root/Spatial/player/head/neck/Camera/aim")
onready var gunp=$Cube/gunpoint
onready var mesh=$Cube
onready var grappoint=$grappoint
onready var tween=$Tween
export var power=1.2
var grapple_Point
var lastlen=0

func _process(delta):
	if isonhand:
		tween.interpolate_property(get_parent(), "rotation",get_parent().rotation,gunp.rotation, 0.1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		if grab:
			canrelease=false
			$ImmediateGeometry.Update(delta)
			gunp.look_at(grapple_Point,Vector3.UP)
		else:
			gunp.rotation=Vector3()
			canrelease=true
			$ImmediateGeometry.Reset()


func _physics_process(delta):
	if isonhand:
		if Input.is_action_just_pressed("graple"):
			if pointer.is_colliding():
				if pointer.get_collider() is StaticBody:
					body=STATIC
				if pointer.get_collider() is KinematicBody:
					body=KINETIC
				if pointer.get_collider() is RigidBody:
					body=RIGID
				grab=true
				bodyitself=pointer.get_collider()
				grapple_Point=pointer.get_collision_point()
				grappoint.get_parent().remove_child(grappoint)
				pointer.get_collider().add_child(grappoint)
				grappoint.set_translation(pointer.get_collider().to_local(grapple_Point))
		grapple_Point=grappoint.get_global_transform().origin
		if Input.is_action_just_released("graple"):
			grab=false
		if grab:
			var le=grapple_Point-gunp.get_global_transform().origin
			if body==STATIC or body==KINETIC:
				if lastlen<le.length():
					get_node("/root/Spatial/player").add_force(le*110+le.normalized(),gunp.get_global_transform().origin-bodyitself.get_global_transform().origin)
				else:
					get_node("/root/Spatial/player").add_force(le*70,gunp.get_global_transform().origin-bodyitself.get_global_transform().origin)
			if body==RIGID:
				get_node("/root/Spatial/player").add_force(le*power/2,gunp.get_global_transform().origin-bodyitself.get_global_transform().origin)
				bodyitself.add_force((-le/2),grapple_Point-bodyitself.get_global_transform().origin)
			lastlen=le.length()
