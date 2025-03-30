extends Control

@export var data: EmailPile

var day_start: float = 8.0
var day_end: float = 24.0

func _process(delta: float):
	var text = "$" + str(data.money) + "\n" + ticks_to_time(
		1.0 - (float(data.time_left) / float(data.day_time_limit))
	)
	if get_parent().game_finished:
		text += "\nGame complete! Thank you for playing!"
	$Label.text = text

func ticks_to_time(time_left: float):
	var minutes_in_day: float = 60.0 * (day_end - day_start)
	var total_minutes: float = minutes_in_day * time_left
	var minutes: int = int(fmod(total_minutes, 60.0))
	var hours: int = int(total_minutes / 60.0)
	var time_of_day: String = "am"

	minutes = 5 * int(minutes / 5)
	hours += day_start
	
	if hours >= 12:
		if hours < 24:
			time_of_day = "pm"
		if hours > 12:
			hours -= 12
	
	var minute_text = str(minutes)
	if minutes < 10:
		minute_text = "0" + minute_text
	
	return str(hours) + ":" + minute_text + " " + time_of_day
