extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://UI/StartGame.tscn")


func _on_Button2_pressed():
	get_tree().quit()
