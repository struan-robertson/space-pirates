extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://Space Station.tscn")

func _on_Button2_pressed():
	get_tree().change_scene("res://UI/HowTo.tscn")

func _on_Button3_pressed():
	get_tree().quit()
