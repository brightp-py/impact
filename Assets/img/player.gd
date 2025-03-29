class_name Player
extends AnimatedSprite2D

var WALK_SPEED: float = 4.0

var DIR_NE: Vector2 = Vector2.UP.rotated(PI/3)
var DIR_SE: Vector2 = Vector2.UP.rotated(2*PI/3)

@export var BUBBLE_RADIUS: float = 10.0

func _ready():
	var vec: Vector2 = Vector2(
		BUBBLE_RADIUS * 0.866,
		BUBBLE_RADIUS * 0.5
	)
	$Collision/NE.target_position = vec * Vector2(1, -1)
	$Collision/SE.target_position = vec * Vector2(1, 1)
	$Collision/SW.target_position = vec * Vector2(-1, 1)
	$Collision/NW.target_position = vec * Vector2(-1, -1)

func _process(delta):
	
	var moving: Vector2 = Vector2(0, 0)
	
	if Input.is_action_pressed("up"):
		moving[1] += 1
	if Input.is_action_pressed("down"):
		moving[1] -= 1
	if Input.is_action_pressed("right"):
		moving[0] += 1
	if Input.is_action_pressed("left"):
		moving[0] -= 1
	
	moving = check_for_collision(moving)
	
	# Don't like this, but temporary.
	# A better choice would be only going in a single direction at a time,
	# prioritizing the one that most recently pressed.
	if moving.length() > 0.0:
		moving /= moving.length()
	
	position += moving[1] * DIR_NE * WALK_SPEED
	position += moving[0] * DIR_SE * WALK_SPEED

func check_for_collision(moving: Vector2) -> Vector2:
	if $Collision/NE.is_colliding() and moving[1] > 0:
		moving[1] = 0
	if $Collision/SE.is_colliding() and moving[0] > 0:
		moving[0] = 0
	if $Collision/SW.is_colliding() and moving[1] < 0:
		moving[1] = 0
	if $Collision/NW.is_colliding() and moving[0] < 0:
		moving[0] = 0
	return moving
