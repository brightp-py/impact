class_name EmailButton
extends Button

var laptop: Laptop
var email_content: VBoxContainer
var choice_container: HBoxContainer

var email_data: Dictionary

func _ready():
	var parent = get_parent()
	laptop = get_parent().get_parent().get_parent().get_parent().get_parent()
	email_content = parent.email_content
	choice_container = parent.choice_container
	pressed.connect(open_email)

func delete():
	queue_free()
	email_content.find_child("Heading").text = "Email deleted"
	email_content.find_child("Description").modulate = "#ffffff88"
	choice_container.visible = false

func load_from_dict(data: Dictionary):
	email_data = data
	text = data["subject"]

func open_email():
	choice_container.visible = true
	email_content.find_child("Description").modulate = "#ffffffff"
	email_content.find_child("Heading").text = email_data["subject"]
	email_content.find_child("Description").text = email_data["content"]
	choice_container.find_child("AR_Pay").find_child("But_Pay").text = email_data["action"]
	
	laptop.current_email = self
