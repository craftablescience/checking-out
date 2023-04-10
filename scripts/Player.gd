class_name Player
extends CharacterBody3D


signal end_game


@export var SPEED := 8.0
@export var SPEED_CROUCH := 2.0 # todo: crouch for an easter egg? (no)
@export var SENSITIVITY := 0.1
@export var HOLD_LERP_SPEED := 8
@export var HOLD_THROW_SPEED := 8

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var held: RigidBody3D = null
var held_parent: Node = null


func held_is_valid() -> bool:
	return held and is_instance_valid(held)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("mv_left", "mv_right", "mv_fwd", "mv_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Move held object
	if held_is_valid():
		var a: Vector3 = %PickupNode.get_global_transform().origin
		var b: Vector3 = held.get_global_transform().origin
		held.set_linear_velocity((a - b) * 10)
		held.angular_damp = 2.0
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var x_rotation: float = event.relative.y * SENSITIVITY
		if not Globals.invert_y:
			x_rotation *= -1
		%RotationHelper.rotate_x(deg_to_rad(x_rotation))
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		var camera_rot: Vector3 = %RotationHelper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -89.99, 45.0)
		%RotationHelper.rotation_degrees = camera_rot
	
	elif event.is_action_pressed("interact"):
		if held and not held_is_valid():
			held = null
			held_parent = null

		if held_is_valid():
			held.reparent(held_parent)
			held.set_linear_velocity(get_real_velocity())
			held.angular_damp = 0.0
			held = null
			held_parent = null
		elif Globals.inside_end_zone:
			end_game.emit()
		else:
			var phys_obj = %PickupRay.get_collider()
			if phys_obj and phys_obj is RigidBody3D:
					held = phys_obj
					held_parent = held.get_parent()
					held.reparent(%PickupNode)
	
	elif event.is_action_pressed("throw"):
		if held and not held_is_valid():
			held = null
			held_parent = null

		if held_is_valid():
			# get look vector
			var dir = (%PickupNode.get_global_transform().origin - %RotationHelper.get_global_transform().origin).normalized()
			held.reparent(held_parent)
			held.set_linear_velocity(get_real_velocity() + dir * HOLD_THROW_SPEED)
			held.angular_damp = 0.0
			held = null
			held_parent = null


func reset() -> void:
	%Camera.current = true
	%RotationHelper.rotation_degrees.x = 0
	rotation_degrees.y = 270.0 # hack hack hack
