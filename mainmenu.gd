extends StaticBody2D

var clickable : bool = false

func _input(event):
	if event is InputEventMouseButton and clickable:
		var status = get_tree().change_scene("res://level1.tscn")
		if not status == OK:
			print("Error", status)

func _on_StaticBody2D_mouse_entered():
	clickable = true

func _on_StaticBody2D_mouse_exited():
	clickable = false
