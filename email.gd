extends Control

# When the email exit button is pressed close this menu
func _on_exit_button_pressed() -> void:
	print("Exit button pressed")

# When the email 1 button is pressed from the list change the text
func email_1_button_pressed() -> void:
	# Set labels text
	$"Details Con/MarginContainer/Email/Heading".text = "EMAIL 1"
	$"Details Con/MarginContainer/Email/Description".text = "This is a payment email."

func email_2_button_pressed() -> void:
	# Set labels text
	$"Details Con/MarginContainer/Email/Heading".text = "EMAIL 2"
	$"Details Con/MarginContainer/Email/Description".text = "This is a SCAM email."

func email_3_button_pressed() -> void:
	# Set labels text
	$"Details Con/MarginContainer/Email/Heading".text = "EMAIL 3"
	$"Details Con/MarginContainer/Email/Description".text = "*****************."

# On Delete button press
func but_delete_pressed() -> void:
	print("Delete button pressed")

# On Pay button press
func but_pay_pressed() -> void:
	print("Pay button pressed")
