extends Control


var player: Player

func _ready():
	player = $SVC/SV/Room/Player
	
	$EmailUI.exit_laptop.connect(close_laptop)
	$EmailUI.change_money.connect($EmailPile.add_money)
	$EmailUI.consequences.connect(apply_consequences)
	
	player.open_laptop.connect(open_laptop)

func open_laptop():
	$EmailUI.visible = true
	player.can_move = false
	$Stats.modulate = "#000000"

func close_laptop():
	$EmailUI.visible = false
	player.can_move = true
	$Stats.modulate = "#ffffff"

func apply_consequences(name: String, paid: bool):
	
	if name == "goose" and paid:
		var goose = $SVC/SV/Room/Bedroom/Goose
		goose.visible = true
		goose.global_position = Vector2(1800.0, 436.0)
