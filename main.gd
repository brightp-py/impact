extends Control


var player: Player

var warning_timer: float = 0.0

func _ready():
	player = $SVC/SV/Room/Player
	
	$EmailUI.exit_laptop.connect(close_laptop)
	$EmailUI.change_money.connect($EmailPile.add_money)
	$EmailUI.consequences.connect(apply_consequences)
	$EmailUI.scam_warning.connect(play_warning)
	
	player.open_laptop.connect(open_laptop)

func _process(delta: float):
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

func apply_consequences(name: String, paid: bool):
	
	if name == "goose" and paid:
		var goose = $SVC/SV/Room/Bedroom/Goose
		goose.visible = true
		goose.global_position = Vector2(3800.0, 436.0)
		$EmailPile.fulfill_condition("goose")
	
	if name == "grandma" and paid:
		$EmailPile.fulfill_condition("grandma")
