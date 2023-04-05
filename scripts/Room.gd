extends Node3D


signal end_game


var MAP_SCENE: PackedScene = null
var map_instance: Node3D = null


func _ready() -> void:
	if Globals.DEBUG_ROOM:
		MAP_SCENE = preload("res://scenes/maps/DebugMap.tscn")
	else:
		MAP_SCENE = preload("res://scenes/maps/RoomMap.tscn")
	
	reset_game()


func use_player_camera() -> void:
	$Player.reset()
	map_instance.get_node("PreviewCamera").current = false


func reset_game() -> void:
	if map_instance:
		map_instance.queue_free()
	map_instance = MAP_SCENE.instantiate()
	$WorldSpawn.add_child(map_instance)
	
	$Player.global_position = map_instance.get_node("Spawn").global_position
	
	map_instance.get_node("PreviewCamera").current = true


func _on_player_end_game() -> void:
	end_game.emit()
