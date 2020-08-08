extends Control

onready var animpl=get_node("/root/Spatial/AnimationPlayer")
var lastplayed
onready var curr=get_node("/root/Spatial/GUIPanel3D")
var resol=Vector2(640,360)

func _ready():
	pass
#	print(ProjectSettings.get("display/window/size/height"))
#	print(ProjectSettings.get("display/window/size/width"))	

func _process(delta):
	pass

func _on_Button3_pressed():
	animpl.play("about")
	lastplayed="about"
	curr.get_child(1).get_child(0).get_child(0).disabled=true
	curr.visible=false
	curr=get_node("/root/Spatial/GUIPanel3D4")
	curr.visible=true

func _on_Button5_pressed():
	get_tree().quit()

func _on_Button2_pressed():
	animpl.play("options")
	lastplayed="options"
	curr.get_child(1).get_child(0).get_child(0).disabled=true
	curr.visible=false
	curr=get_node("/root/Spatial/GUIPanel3D2")
	curr.visible=true

func _on_Button_pressed():
	animpl.play("play")
	lastplayed="play"
	curr.get_child(1).get_child(0).get_child(0).disabled=true
	curr.visible=false
	curr=get_node("/root/Spatial/GUIPanel3D3")
	curr.visible=true

func _on_b_pressed():
	animpl.play_backwards(lastplayed)
	curr.get_child(1).get_child(0).get_child(0).disabled=true
	curr.visible=false
	curr=get_node("/root/Spatial/GUIPanel3D")
	curr.visible=true

func _on_AnimationPlayer_animation_finished(anim_name):
	curr.get_child(1).get_child(0).get_child(0).disabled=false


func _on_itch_pressed():
	OS.shell_open("https://danidev.itch.io/karlson")


func _on_steam_pressed():
	OS.shell_open("https://store.steampowered.com/app/1228610/KARLSON/")


func _on_testing_pressed():
	get_tree().change_scene("res://scene/testing.tscn")


func _on_accept_pressed():
	OS.set_window_size(resol)
	var save_game = File.new()
	save_game.open("user://resol.save", File.WRITE)
	save_game.store_line(to_json({"resx":resol.x,"resy":resol.y}))
	save_game.close()

func _on_OptionButton_item_selected(index):
	match index:
		0:
			resol=Vector2(640,360)
		1:
			resol=Vector2(960,540)
		2:
			resol=Vector2(1280,720)
		3:
			resol=Vector2(1920,1080)
