extends Control

# When the email exit button is pressed close this menu
func _on_exit_button_pressed() -> void:
	print("Exit button pressed")

# When the email 1 button is pressed from the list change the text
func but_email_1_pressed() -> void:
	# Set labels text
	$"Details Con/MarginContainer/Email/Heading".text = "EMAIL 1"
	$"Details Con/MarginContainer/Email/Description".text = "This is a payment email."

func but_email_2_pressed() -> void:
	# Set labels text
	$"Details Con/MarginContainer/Email/Heading".text = "EMAIL 2"
	$"Details Con/MarginContainer/Email/Description".text = "This is a SCAM email."

func but_email_3_pressed() -> void:
	# Set labels text
	$"Details Con/MarginContainer/Email/Heading".text = "EMAIL 3"
	$"Details Con/MarginContainer/Email/Description".text = "*****************."

# On Delete button press
func but_delete_pressed() -> void:
	print("Delete button pressed")

# On Pay button press
func but_pay_pressed() -> void:
	print("Pay button pressed")
