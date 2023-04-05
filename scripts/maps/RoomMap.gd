extends Node3D


func object_collected(body: Node3D) -> void:
	if body is Player:
		Globals.inside_end_zone = true
		return
	
	if not body is RigidBody3D:
		return
	
	if body.is_in_group("PlayerOwned"):
		Globals.player_collected += 1
		body.queue_free()
	elif body.is_in_group("SchoolOwned"):
		Globals.school_collected += 1
		body.queue_free()


func _on_collection_area_1_body_entered(body: Node3D) -> void:
	object_collected(body)


func _on_collection_area_2_body_entered(body: Node3D) -> void:
	object_collected(body)


func _on_collection_area_1_body_exited(body: Node3D) -> void:
	if body is Player:
		Globals.inside_end_zone = false


func _on_collection_area_2_body_exited(body: Node3D) -> void:
	if body is Player:
		Globals.inside_end_zone = false
