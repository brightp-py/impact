class_name Player
extends Node2D

signal open_laptop
signal go_to_sleep
signal earn_money(amount: int)

var WALK_SPEED: float = 300.0

var DIR_NE: Vector2 = Vector2.UP.rotated(PI/3)
var DIR_SE: Vector2 = Vector2.UP.rotated(2*PI/3)

@export var BUBBLE_RADIUS: float = 10.0

var can_move: bool = true
var at_work: bool = false
var working_hard: bool = false
var direction_last_pressed_was_vertical: bool = true
var facing_up: bool = false

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
	
	if can_move:
		if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
			direction_last_pressed_was_vertical = true
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
			direction_last_pressed_was_vertical = false
		
		var moving: Vector2 = Vector2(0, 0)
		
		if Input.is_action_pressed("up"):
			moving[1] += 1
		if Input.is_action_pressed("down"):
			moving[1] -= 1
		if Input.is_action_pressed("right"):
			moving[0] += 1
		if Input.is_action_pressed("left"):
			moving[0] -= 1
		
		if moving.length_squared() > 1.0:
			if direction_last_pressed_was_vertical:
				moving[0] = 0
			else:
				moving[1] = 0
		
		moving = check_for_collision(moving)
		
		position += moving[1] * DIR_NE * WALK_SPEED * delta
		position += moving[0] * DIR_SE * WALK_SPEED * delta
		
		check_for_interaction()
		if Input.is_action_just_pressed("interact"):
			interact()
	
		do_animation(moving)
	
	else:
		$Label.visible = false
		do_animation(Vector2(0, 0))
		
		if at_work:
			var mouse: Vector2 = get_global_mouse_position()
			if Input.is_action_pressed("click") and mouse.length() < 150.0:
				working_hard = true
				get_parent().find_child("Work").find_child("Button").texture.region.position.x = 32.0
			else:
				if working_hard:
					earn_money.emit(1.0)
				working_hard = false
				get_parent().find_child("Work").find_child("Button").texture.region.position.x = 0.0
			
			if Input.is_action_just_pressed("interact"):
				return_home()

func check_for_collision(moving: Vector2) -> Vector2:
	if $Collision/NE.is_colliding():
		if moving[1] > 0:
			moving[1] = 0
		else:
			move_away($Collision/NE)
	if $Collision/SE.is_colliding():
		if moving[0] > 0:
			moving[0] = 0
		else:
			move_away($Collision/SE)
	if $Collision/SW.is_colliding():
		if moving[1] < 0:
			moving[1] = 0
		else:
			move_away($Collision/SW)
	if $Collision/NW.is_colliding():
		if moving[0] < 0:
			moving[0] = 0
		else:
			move_away($Collision/NW)
	return moving

func move_away(ray: RayCast2D):
	var point = ray.get_collision_point()
	var d = ray.global_transform.origin.distance_to(point) / scale.x
	if d < BUBBLE_RADIUS * 0.8:
		position -= ray.target_position * 0.25

func check_for_interaction():
	if not can_move:
		$Label.visible = false
		return
	
	var areas: Array[Area2D] = $Area2D.get_overlapping_areas()
	
	if areas.size() == 0:
		$Label.visible = false
		return
	
	var space: InteractSpace = areas[0]
	$Label.text = space.description
	$Label.visible = true

func interact():
	var areas: Array[Area2D] = $Area2D.get_overlapping_areas()
	
	if areas.size() == 0:
		$Label.visible = false
		return
	
	var space: InteractSpace = areas[0]
	
	if space.interaction == "mirror":
		$Sprite.modulate = "#231242"
	
	elif space.interaction == "laptop":
		open_laptop.emit()
	
	elif space.interaction == "bed":
		go_to_sleep.emit()
	
	elif space.interaction == "door":
		go_to_work()
	
	elif space.interaction == "goose":
		space.get_parent().shoo()

func go_to_work():
	visible = false
	can_move = false
	at_work = true
	get_parent().find_child("Bedroom").visible = false
	get_parent().find_child("Work").visible = true

func return_home():
	visible = true
	can_move = true
	at_work = false
	get_parent().find_child("Bedroom").visible = true
	get_parent().find_child("Work").visible = false

func do_animation(moving: Vector2):
	if moving.length_squared() == 0:
		if Input.is_action_pressed("up"):
			facing_up = true
			$Sprite.scale.x = -1.0
		if Input.is_action_pressed("left"):
			facing_up = true
			$Sprite.scale.x = 1.0
		if Input.is_action_pressed("down"):
			facing_up = false
			$Sprite.scale.x = 1.0
		if Input.is_action_pressed("right"):
			facing_up = false
			$Sprite.scale.x = -1.0
		if facing_up:
			$Sprite.play("face_up")
		else:
			$Sprite.play("face_down")
	else:
		facing_up = moving[0] < 0 or moving[1] > 0
		if facing_up:
			$Sprite.play("walk_up")
		else:
			$Sprite.play("walk_down")
		if moving[0] > 0 or moving[1] > 0:
			$Sprite.scale.x = -1.0
		else:
			$Sprite.scale.x = 1.0
