extends Node

var time_scale: float = 1.0
var player_speed: float = 60.0
var player_jump_vel = -140

func change_time():
	if time_scale > 4:
		time_scale = 4
	elif time_scale < 0.25:
		time_scale = 0.25
	
