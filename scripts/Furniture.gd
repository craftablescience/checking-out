extends Node3D


var original_transforms: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is RigidBody3D:
			original_transforms[child.name] = child.global_transform


func _on_teleport_body_entered(body: Node) -> void:
	if body is RigidBody3D:
		# tiered for editor autocomplete bug
		if original_transforms.has(body.name):
			body.global_transform = original_transforms[body.name]
			body.angular_velocity = Vector3(0, 0, 0)
			body.linear_velocity = Vector3(0, 0, 0)
