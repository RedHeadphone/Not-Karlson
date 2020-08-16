extends RigidBody

var caman=0
var sensitivity=0.3
var vel=Vector3()
var speed =600
var maxspeed=12
var direction=Vector3()
var mousepos=Vector2()
var last=Vector2()
var aim=Vector3()
var theta
var relvel=Vector3()
var wallspeed
var walljumpdir
var groundis=false
var legcontactcount=0
var counter=200
var crouching=false

onready var camera=$head/neck
onready var aimer=$head/neck/Camera/aim
onready var head=$head
onready var gunpos=$head/neck/Camera/Position3D
onready var gun =null
onready var tween = $Tween
onready var groundcheck=$RayCast
onready var wallchecker=$RayCast/Spatial

onready var gunfp=gunpos.translation
var gunpp
var ok=false
var gunnear=false
var gunpicked=false
var oldrot=Vector3()
var togo=Vector3()
var torot=Vector3()
var let=0
var camside=0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		mousepos=event.relative

func _process(delta):
	cameralook(delta)

func _physics_process(delta):
	get_node("/root/Spatial/Control/Label").text=str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
	movement(delta)
	gunpp=aimer.get_global_transform().origin+-50*aimer.get_global_transform().basis.y
	if aimer.is_colliding():
		gunpp=aimer.get_collision_point()
	gunpicksys(delta)
	if Input.is_action_just_pressed("test"):
		Engine.time_scale=0.05
	if Input.is_action_just_released("test"):
		Engine.time_scale=1

func gunpicksys(delta):
	if ok:
		gunpick()
		if gunpicked:
			gunmovement(delta)
		if Input.is_action_just_pressed("throw") and gun.canrelease:
			ok=false
	else:
		gundrop()
		if Input.is_action_just_pressed("pickup"):
			var li=$"gun check".get_overlapping_bodies()
			var mypos=get_global_transform().origin
			if len(li)>0:
				gun=li[0]
				var mil=(gun.get_global_transform().origin-mypos).length()
				for i in li:
					if (i.get_global_transform().origin-mypos).length()<mil:
						gun=i
				ok=true

func gunmovement(delta):
	var curr=gunpos.get_global_transform().basis.get_euler()
	if curr.y<0:
		curr.y+=6.28
	var angularvel=curr-oldrot
	if abs(angularvel.y)>3.14:
		if curr.y>3.14 and oldrot.y<3.14:
			angularvel.y-=6.28
		if curr.y<3.14 and oldrot.y>3.14:
			angularvel.y+=6.28
	torot=-angularvel*2
	var limit=0.1
	var desired_pos=Vector3()
	desired_pos = Vector3(0,0,relvel.x)+Vector3(relvel.y,0,0)-Vector3(0,vel.y,0)*0.6
	desired_pos/=50
	if abs(desired_pos.x)<limit:
		togo.x=desired_pos.x
	if abs(desired_pos.y)<limit:
		togo.y=desired_pos.y
	if abs(desired_pos.z)<limit:
		togo.z=desired_pos.z
	gun.translation=lerp(gun.translation,togo,delta*10)
	gun.rotation=lerp(gun.rotation,torot,delta*10)
	oldrot=curr

func gundrop():
	if gunpicked:
		gun.mode=0
		gun.get_child(1).disabled=false
		gunpicked=false
		gun.get_child(0).set_layer_mask(1)
		var temp=gun.get_global_transform()
		gunnear=false
		gun.get_parent().remove_child(gun)
		get_node("/root/Spatial").add_child(gun)
		gun.set_global_transform(temp)
		gun.add_torque(Vector3(-3,0,0))
		gun.add_central_force((gunpp-temp.origin).normalized()*300+vel*100)
		gun.isonhand=false

func gunpick():
	if not gunnear:
		var temp=gun.get_global_transform()
		gun.get_parent().remove_child(gun)
		gunpos.add_child(gun)
		gun.set_global_transform(temp)
		gun.mode=3
		gun.get_child(1).disabled=true
		gunnear=true
		gun.get_child(0).set_layer_mask(4)
		tween.interpolate_property(gun, "translation",gun.translation,Vector3(), 0.4,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_property(gun, "rotation_degrees",gun.rotation_degrees,gunpos.rotation_degrees , 0.4,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	if (gunpos.get_global_transform().origin-gun.get_global_transform().origin).length()<0.1 and not gunpicked:
		gunpicked=true
		gun.isonhand=true
		tween.stop_all()

func movement(delta):
	aim =head.get_global_transform().basis
	vel=get_linear_velocity()
	theta=Vector2(aim.z.x,aim.z.z).angle_to(Vector2(1,0))
	relvel=Vector2()
	relvel.x=-vel.x*cos(theta)+vel.z*sin(theta)
	relvel.y=vel.z*cos(theta)+vel.x*sin(theta)
	
	var x=0
	var y=0
	direction=Vector3()
	
	if not $RayCast.is_colliding() and not groundis:
		speed=400
	else:
		speed=600
	
	if Input.is_action_pressed("ui_up") and (counter!=40 or not $RayCast.is_colliding()):
		direction-=aim.z
		x=1
	if Input.is_action_pressed("ui_down") and (counter!=40 or not $RayCast.is_colliding()):
		direction+=aim.z
		x=-1
	if Input.is_action_pressed("ui_left") and (counter!=40 or not $RayCast.is_colliding()) :
		direction-=aim.x
		y=1
	if Input.is_action_pressed("ui_right") and (counter!=40 or not $RayCast.is_colliding()) :
		direction+=aim.x
		y=-1
	if abs(relvel.x)>maxspeed:
		x=0
	if abs(relvel.y)>maxspeed:
		y=0
	direction=direction.normalized()*speed*delta
	if groundcheck.is_colliding() and  Input.is_action_just_pressed("ui_select"):#
		direction.y=450
	self.add_central_force(direction)
	
	if groundcheck.is_colliding() or groundis:
		countermovement(relvel,delta,aim,x,y)
	crouch()
	wallrun()

func wallrun():
	if groundis and not groundcheck.is_colliding():
		counter=150
		walljumpdir=wallchecker.get_global_transform().basis.y
		wallspeed=vel
		wallspeed.y=0
		if wallspeed.length()>10:
			wallspeed=10
		else:
			wallspeed=wallspeed.length()
		if not (wallchecker.get_child(0).is_colliding() and wallchecker.get_child(1).is_colliding()):
			wallchecker.rotate_y(0.78539816)
		else:
			let =walljumpdir.angle_to(camera.get_global_transform().basis.x)
			if let<PI/2:
				let=-cos(let)
			else:
				let=let-PI
				let=cos(let)
			let*=15
			add_central_force(-walljumpdir*10)
			if Input.is_action_just_pressed("ui_select"):
				add_central_force((walljumpdir+Vector3(0,0.6,0))*500)
		if vel.y<0:
			add_central_force(Vector3(0,9.8,0)*wallspeed/10)
	else:
		let=0

func cameralook(delta):
	camside=lerp(camside,let,delta*4)
	if last==mousepos:
		mousepos=Vector2()
	head.rotate_z(deg2rad(mousepos.x*sensitivity))
	caman+=(-mousepos.y*sensitivity)
	caman=clamp(caman,-90,75)
	camera.set_rotation_degrees(Vector3(caman,0,camside))
	last = mousepos

func crouch():
	if crouching:
		counter=40
	else:
		counter=200
	if Input.is_action_just_pressed("ui_slide"):
		crouching=true
		if gunpicked:
			gun.get_parent().remove_child(gun)
		$CollisionShape.get_shape().set_height(0.1)
		if gunpicked:
			gunpos.add_child(gun)
		$CollisionShape/MeshInstance.get_mesh().mid_height=0.1
		$head.translation=Vector3(0,0,-0.34)
		$RayCast.translation=Vector3(0,0,0.4)
		add_central_force(Vector3(0,-1,0))
	if Input.is_action_just_released("ui_slide"):
		crouching=false
		if gunpicked:
			gun.get_parent().remove_child(gun)
		$CollisionShape.get_shape().set_height(1.9)
		if gunpicked:
			gunpos.add_child(gun)
		$CollisionShape/MeshInstance.get_mesh().mid_height=1.9
		$head.translation=Vector3(0,0,-0.68)
		$RayCast.translation=Vector3(0,0,1.282)
		add_central_force(Vector3(0,1,0))

func countermovement(mag,delta,aim,x,y):
	if (abs(mag.x) > 0.01  and x==0) or (mag.x < 0.01 and x > 0) or (mag.x > 0.01 and x < 0):
		add_central_force(delta* mag.x*aim.z*counter)
	if (abs(mag.y) > 0.01  and y==0) or (mag.y < 0.01 and y > 0) or (mag.y > 0.01 and y < 0):
		add_central_force(delta* mag.y*aim.x*counter)

func _on_jump_body_entered(body):
	if body is StaticBody:
		legcontactcount+=1
	if legcontactcount>0:
		groundis=true

func _on_jump_body_exited(body):
	if body is StaticBody:
		legcontactcount-=1
	if legcontactcount==0:
		groundis=false
