extends Area

onready var player=get_node("/root/Spatial/player")
func _on_Area_body_exited(body):
	if player.gun==body:
		pass
	elif body!=player:
		body.queue_free()
	else:
		get_tree().reload_current_scene()
