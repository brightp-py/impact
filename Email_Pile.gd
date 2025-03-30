class_name EmailPile
extends Node


var money: int = 0
var time_left: float = 0.0
var game_over: bool = false
var current_email: Dictionary = {}
var deck: Array = []

var day_timer = 0
var day_time_limit = 210
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

func start_game():
	#money = randi_range(4000, 12000)
	money = 4000
	emit_signal("money_updated", money)
	start_new_day()

func start_new_day():
	day_timer = 0
	time_left = day_time_limit
	load_email_deck()
	draw_new_emails()
	#$Timer.start()

func end_of_day():
	day_number+= 1
	start_new_day()

#func _on_Timer_timeout():
	#if game_over:
		#return
#
	#time_left -= 1
	#day_timer += 1
	#emit_signal("time_updated", time_left)
#
	#if time_left <= 0 or day_timer >= day_time_limit:
		#fail_due_to_time()


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
				"action": fields[9].strip_edges().lstrip("\"").rstrip("\"")
			}
			deck.append(email)

	file.close()
	
	## IMPORTANT: Bring this back when we have a complete set of emails!!!!!
	deck.shuffle()
	
	#deck = deck.slice(0, calculate_email_count())  # Scale emails by day

func calculate_email_count() -> int:
	return clamp(4 + int(day_number * 0.8), 4, 12)

func draw_new_emails():
	for i in range(calculate_email_count()):
		laptop.add_email(deck.pop_front())
	laptop.open_first_email()
	#if deck.size() == 0:
		#end_of_day()
		#return
#
	#current_email = deck.pop_front()
	#emit_signal("email_loaded", current_email)

# --- Decision Logic ---
func make_decision(is_phishing_guess: bool):
	if current_email == {}:
		return

	var email_value = 0

	if is_phishing_guess == current_email["is_phishing"]:
		email_value = current_email["reward_money"]
	else:
		email_value = current_email["penalty_money"]
		time_left -= current_email["penalty_time"]

	money += email_value
	emit_signal("money_updated", money)
	emit_signal("time_updated", time_left)

	if money <= 0:
		end_game("You ran out of money.")
	elif time_left <= 0:
		fail_due_to_time()
	#else:
		#draw_next_email()

# --- Fail Conditions ---
func fail_due_to_time():
	if deck.size() > 0:
		end_game("You failed to finish your emails in time.")
	else:
		end_of_day()

func end_game(reason: String = "Game Over"):
	game_over = true
	#$Timer.stop()
	emit_signal("game_failed", reason)

# --- Bill Payment Handling ---
func add_money(amount: int):
	money += amount

func pay_bill():
	if current_email != {} and current_email["is_phishing"] == false:
		var bill_amount = randi_range(200, 600)
		money -= bill_amount
		emit_signal("money_updated", money)
		if money <= 0:
			end_game("You paid too many bills and ran out of money.")
		#else:
			#draw_next_email()

func skip_bill():
	#draw_next_email()
	pass
