class_name Goose

extends Node2D

var MOVE_SPEED: float = 4.0

var flap_time: float = 0
var right: bool = true
var moving: bool = false

func _process(delta):
	if flap_time > 0:
		flap_time -= delta
		$Sprite.play("flap")
		moving = false
		return
	
	if moving:
		if randf() < 0.01:
			moving = false
	else:
		if randf() < 0.002:
			moving = true
			right = (randf() - 0.5) * 200 > position.x
	
	if moving:
		$Sprite.play("walk")
		if right:
			position.x += MOVE_SPEED
		else:
			position.x -= MOVE_SPEED
	else:
		$Sprite.play("default")
	
	if right:
		$Sprite.scale.x = 1.0
	else:
		$Sprite.scale.x = -1.0
	
func shoo():
	flap_time = 1.0
