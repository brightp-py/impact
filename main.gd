extends Control


var player: Player

var warning_timer: float = 0.0
var state: String = "playing"
var load_time: float = 0.0

func _ready():
	player = $SVC/SV/Room/Player
	
	$EmailUI.exit_laptop.connect(close_laptop)
	$EmailUI.change_money.connect($EmailPile.add_money)
	$EmailUI.consequences.connect(apply_consequences)
	$EmailUI.scam_warning.connect(play_warning)
	
	player.open_laptop.connect(open_laptop)
	player.go_to_sleep.connect(new_day)
	player.earn_money.connect($EmailPile.add_money)
	player.show_interact_label.connect(show_interact_label)
	player.hide_interact_label.connect(hide_interact_label)
	
	$SVC/SV/Room/BGMusic.queue_up(7.0)
	$Black/AnimationPlayer.play("fade_out")

func _process(delta: float):
	if state == "sleeping":
		if not $Black/AnimationPlayer.is_playing():
			state = "loading"
			load_time = 3.0
			load_new_day()
	
	elif state == "loading":
		load_time -= delta
		if load_time <= 0:
			state = "playing"
			$Black/AnimationPlayer.play("fade_out")
			player.can_move = true
	
	$Stats/Warning.visible = false
	if warning_timer <= 0.0:
		return
	
	warning_timer -= delta
	if fmod(warning_timer, 0.6) >= 0.15:
		$Stats/Warning.visible = true

func play_warning():
	warning_timer = 1.79

func open_laptop():
	$EmailUI.visible = true
	player.can_move = false

func close_laptop():
	$EmailUI.visible = false
	player.can_move = true

func show_interact_label(text: String):
	$Stats/InteractLabel.text = text
	$Stats/InteractLabel.visible = true

func hide_interact_label():
	$Stats/InteractLabel.visible = false

func new_day():
	$Black/AnimationPlayer.play("fade_in")
	state = "sleeping"
	player.return_home()
	player.can_move = false
	$SVC/SV/Room/BGMusic.fade_out(0.5)

func load_new_day():
	player.position = Vector2(-500, 400)
	var children = $"EmailUI/VBox/HBox/Email List Con/ScrollContainer/MarginContainer/Buttons".get_children()
	for child in children:
		child.open_email()
		$EmailUI.but_delete_pressed()
	$EmailPile.end_of_day()
	$SVC/SV/Room/BGMusic.queue_up(7.0)

func apply_consequences(name: String, paid: bool):
	
	if name == "goose" and paid:
		var goose = $SVC/SV/Room/Bedroom/Goose
		goose.visible = true
		goose.global_position = Vector2(3800.0, 436.0)
		$EmailPile.fulfill_condition("goose")
	
	if name == "grandma" and paid:
		$EmailPile.fulfill_condition("grandma")
	
	if name == "neighbor" and not paid:
		$EmailPile.fulfill_condition("deny_noise")
	
	if name == "electricity" and not paid:
		$EmailPile.has_electricity = false
	
	if name == "neighbor" and paid:
		$SVC/SV/Room/BGMusic.make_quiet()
	
	if name == "lottery" and paid:
		if randf() < 0.05:
			$EmailPile.fulfill_condition("win_lottery")
