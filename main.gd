extends Control


var player: Player

func _ready():
	player = $SubViewportContainer/SubViewport/Room/Player
	$EmailUI.exit_laptop.connect(close_laptop)
	player.open_laptop.connect(open_laptop)

func open_laptop():
	$EmailUI.visible = true
	player.can_move = false

func close_laptop():
	$EmailUI.visible = false
	player.can_move = true
