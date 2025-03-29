class_name Goose

extends Node2D

var MOVE_SPEED: float = 200.0

var time_until_check: float = 0.1
var flap_time: float = 0
var right: bool = true
var moving: bool = false

func _process(delta):
	time_until_check -= delta
	
	if flap_time > 0:
		flap_time -= delta
		$Sprite.play("flap")
		moving = false
		return
	
	if time_until_check < 0:
		time_until_check = 0.1 
		if moving:
			if randf() < 0.1:
				moving = false
		else:
			if randf() < 0.02:
				moving = true
				right = (randf() - 0.5) * 200 > position.x
	
	if moving:
		$Sprite.play("walk")
		if right:
			position.x += MOVE_SPEED * delta
		else:
			position.x -= MOVE_SPEED * delta
	else:
		$Sprite.play("default")
	
	if right:
		$Sprite.scale.x = 1.0
	else:
		$Sprite.scale.x = -1.0
	
func shoo():
	flap_time = 1.0
