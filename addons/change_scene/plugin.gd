tool
extends EditorPlugin



func _enter_tree():
	#add_custom_type("ChangeScene", "Node", preload("Changescene.gd"), null)
	add_autoload_singleton("ChangeScene", "res://addons/change_scene/ChangeScene.tscn")
	pass

func _exit_tree():
	#remove_custom_type("ChangeScene")
	remove_autoload_singleton("ChangeScene")
	pass
