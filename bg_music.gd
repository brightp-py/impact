extends AudioStreamPlayer2D

var main_volume: float = 0.0
var timer: float = 0.0
var fade_time: float = 1.0
var active: bool = false
var fading: bool = false
var quiet: bool = false

func _process(delta: float):
	if active:
		timer -= delta
		if timer <= 0.0:
			play()
			active = false
	
	elif fading:
		timer -= delta
		volume_db = main_volume + 80.0 * ((timer / fade_time) - 1.0)
		if timer <= 0:
			volume_db = main_volume
			if playing:
				stop()
			fading = false

func queue_up(wait: float):
	if playing:
		stop()
	volume_db = main_volume
	timer = wait
	active = true
	fading = false

func fade_out(wait: float):
	timer = wait
	fade_time = wait
	fading = true

func make_quiet():
	main_volume = -4.0
	volume_db = main_volume

func toggle():
	if playing:
		stop()
	else:
		play()
