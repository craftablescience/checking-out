@icon("res://textures/dev.png")
class_name Stopwatch
extends Node


@export var started := false
@export var paused := false

var elapsed_time := 0.0


func _ready() -> void:
	reset()


func start() -> void:
	reset()
	started = true


func pause() -> void:
	paused = true


func resume() -> void:
	paused = false


func stop() -> void:
	started = false
	paused = false


func reset() -> void:
	elapsed_time = 0.0
	started = false
	paused = false


func _physics_process(delta: float) -> void:
	if started and not paused:
		elapsed_time += delta
