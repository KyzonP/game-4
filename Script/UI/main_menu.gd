extends Control


func _on_local_button_down():
	var scene = load("res://Scenes/TestTest.tscn").instantiate()
	get_tree().root.add_child(scene)
	
	self.hide()


func _on_online_button_down():
	var scene = load("res://Scenes/UI/Multiplayer.tscn").instantiate()
	get_tree().root.add_child(scene)
	
	self.hide()


func _on_ai_button_down():
	var scene = load("res://Scenes/AITest.tscn").instantiate()
	get_tree().root.add_child(scene)
	
	self.hide()


func _on_quit_button_down():
	get_tree().quit()
