extends Node2D

var pitches: Array = [
	1.0,
	1.5,
	1.18518,
	1.58025,
	1.5,
	1.875,
	1.58025,
	0.9375
]
var ind: int = 0

func play_sound():
	$Sound.pitch_scale = pitches[ind] * 0.4 + 0.8
	ind = (ind + randi_range(1, 2)) % pitches.size()
	$Sound.play()
