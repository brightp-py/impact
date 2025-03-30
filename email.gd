class_name Laptop
extends Control

signal exit_laptop
signal change_money(amount: int)
signal consequences(name: String, paid: bool)
signal scam_warning

var current_email: EmailButton

# Add a new email option on the left side
func add_email(email_data: Dictionary):
	const email_button_obj = preload("res://UI/but_email.tscn")
	var but_email: EmailButton = email_button_obj.instantiate()
	but_email.load_from_dict(email_data)
	$"VBox/HBox/Email List Con/ScrollContainer/MarginContainer/Buttons".add_child(but_email)

func open_first_email():
	$"VBox/HBox/Email List Con/ScrollContainer/MarginContainer/Buttons".get_children()[0].open_email()

# When the email exit button is pressed close this menu
func _on_exit_button_pressed() -> void:
	#print("Exit button pressed")
	exit_laptop.emit()

# On Delete button press
func but_delete_pressed() -> void:
	#print("Delete button pressed")
	change_money.emit(current_email.email_data["penalty_money"])
	consequences.emit(current_email.email_data["signal"], false)
	current_email.delete()

# On Pay button press
func but_pay_pressed() -> void:
	#print("Pay button pressed")
	change_money.emit(current_email.email_data["reward_money"])
	consequences.emit(current_email.email_data["signal"], true)
	if current_email.email_data["is_phishing"]:
		scam_warning.emit()
	current_email.delete()
