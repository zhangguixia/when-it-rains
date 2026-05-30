extends Node

signal rain_started(visit: int)
signal rain_stopped(visit: int)

var visit := 1
var raining := false

func start_first_rain() -> void:
	visit = 1
	raining = true
	rain_started.emit(visit)

func stop_rain() -> void:
	raining = false
	rain_stopped.emit(visit)

func start_second_rain() -> void:
	visit = 2
	raining = true
	rain_started.emit(visit)
