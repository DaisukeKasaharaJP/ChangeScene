extends Node

const GROUP_NAME = "res://addons/change_scene/ChangeScene.gd"

var fade:bool = true
var scene_list:Array = []

onready var FadeScreenLayer = $FadeScreenLayer
onready var BlackScreen = $FadeScreenLayer/BlackScreen
onready var ScreenPlayer = $ScreenPlayer

#
#
#
func _init():
	print("[ChangeScene] _init")
#
#
#
func _enter_tree():
	print("[ChangeScene] _enter_tree")
	var _current_scene = get_tree().get_current_scene()
	if _current_scene.has_method('_launcher'):
		_current_scene._launcher()
	# _current_scene.connect("tree_entered", self, "_on_current_scene_tree_enterd", [_current_scene])

#
#
#
func _ready():
	FadeScreenLayer.hide()


#
#
#
func add_loading(tscn:String, clear:bool=true):
	if clear:
		for child in BlackScreen.get_children():
			BlackScreen.remove_child(child)
	BlackScreen.add_child(load(tscn).instance())

#
#
#
func usefade(val:bool):
	fade = val


#
#  change scene with arguments
#
func enter_scene(path:String, args:Dictionary={}):
	
	if fade:
		ScreenPlayer.play("FadeOut")
		yield(ScreenPlayer,"animation_finished")
	
	var _current_scene = get_tree().get_current_scene()
	var _root = get_tree().get_root()
	if _current_scene:
		_root.remove_child(_current_scene)		

	var next_scene = load(path).instance()
	if next_scene.has_method('_enter_scene'):
		next_scene._enter_scene(args)
	_root.add_child(next_scene)
	get_tree().set_current_scene(next_scene)
	
	if fade:
		ScreenPlayer.play("FadeIn")
		yield(ScreenPlayer,"animation_finished")	




#
#  change scene with arguments
#
func push_scene(path:String, args:Dictionary={}):
	
	if fade:
		ScreenPlayer.play("FadeOut")
		yield(ScreenPlayer,"animation_finished")
	
	var _current_scene = get_tree().get_current_scene()
	var _root = get_tree().get_root()
	if _current_scene:
		_root.remove_child(_current_scene)
		scene_list.append(_current_scene)
	
	var next_scene = load(path).instance()
	next_scene.add_to_group(GROUP_NAME)
	if next_scene.has_method('_enter_scene'):
		next_scene._enter_scene(args)
	_root.add_child(next_scene)
	get_tree().set_current_scene(next_scene)
	
	if fade:
		ScreenPlayer.play("FadeIn")
		yield(ScreenPlayer,"animation_finished")
	


#
#  change scene with arguments
#
func pop_scene(step:int=1):
	
	if fade:
		ScreenPlayer.play("FadeOut")
		yield(ScreenPlayer,"animation_finished")
	
	var _current_scene = get_tree().get_current_scene()
	var _root = get_tree().get_root()
	if _current_scene:
		_root.remove_child(_current_scene)
		
	
	if scene_list.size() > 0:
		var next_scene
		for i in range(step):
			next_scene = scene_list.pop_back()
	
		if next_scene:
			_root.add_child(next_scene)
			get_tree().set_current_scene(next_scene)
	
	
	if fade:
		ScreenPlayer.play("FadeIn")
		yield(ScreenPlayer,"animation_finished")
