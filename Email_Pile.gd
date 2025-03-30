class_name EmailPile
extends Node


var money: int = 0
var time_left: float = 0.0
var game_over: bool = false
var has_electricity: bool = true
var current_email: Dictionary = {}
var deck: Array = []
var conditions_fulfilled = []
var conditional_deck: Dictionary = {}

var day_timer = 0
var day_time_limit = 140
var day_number = 1

@export var laptop: Laptop

signal money_updated(value)
signal time_updated(value)
signal email_loaded(email)
signal game_failed(reason)

func _ready():
	randomize()
	start_game()

func _process(delta):
	time_left -= delta
	if time_left < 0:
		get_parent().new_day()

func start_game():
	money = 4000
	emit_signal("money_updated", money)
	load_email_deck()
	start_new_day()

func start_new_day():
	day_timer = 0
	time_left = day_time_limit
	draw_new_emails()
	if not has_electricity:
		laptop.lose_wifi()

func end_of_day():
	day_number+= 1
	start_new_day()

func load_email_deck():
	var file_path = "res://data/emails.tsv"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Could not open emails.csv")
		return

	deck.clear()
	var is_first = true

	while not file.eof_reached():
		var line = file.get_line()
		if is_first:
			is_first = false
			continue

		var fields = line.split("\t")
		if fields.size() >= 8:
			var email = {
				"subject": fields[0].strip_edges().lstrip("\"").rstrip("\""),
				"content": fields[1].strip_edges().lstrip("\"").rstrip("\"").replace("\\n", "\n"),
				"is_phishing": fields[2].strip_edges().to_lower() == "true",
				"reward_money": int(fields[3]),
				"penalty_money": int(fields[4]),
				"penalty_time": int(fields[5]),
				"difficulty": fields[6].strip_edges(),
				"length": fields[7].strip_edges().to_lower(),
				"signal": fields[8].strip_edges().lstrip("\"").rstrip("\""),
				"action": fields[9].strip_edges().lstrip("\"").rstrip("\""),
				"condition": fields[10].strip_edges().lstrip("\"").rstrip("\"")
			}
			if email["condition"] == "":
				deck.append(email)
			else:
				if not conditional_deck.has(email["condition"]):
					conditional_deck[email["condition"]] = []
				conditional_deck[email["condition"]].append(email)

	file.close()
	
	## IMPORTANT: Bring this back when we have a complete set of emails!!!!!
	deck.shuffle()
	
	#deck = deck.slice(0, calculate_email_count())  # Scale emails by day

func calculate_email_count() -> int:
	return clamp(4 + int(day_number * 0.8), 4, 12)

func draw_new_emails():
	for i in range(calculate_email_count()):
		if deck.size() > 0:
			laptop.add_email(deck.pop_front())
	laptop.open_first_email()

func fulfill_condition(name: String):
	conditions_fulfilled.append(name)
	if not conditional_deck.has(name):
		return
	deck.append_array(conditional_deck[name])
	deck.shuffle()

func add_money(amount: int):
	money += amount
