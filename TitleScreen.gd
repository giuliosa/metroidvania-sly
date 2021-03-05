extends Node

onready var startButton = get_node('MarginContainer/VBoxContainer/VBoxContainer/Button')
onready var exitButton = get_node('MarginContainer/VBoxContainer/VBoxContainer/Button2')

func _ready():
	startButton.grab_focus()

func _physics_process(delta):
	if startButton.is_hovered() == true:
		startButton.grab_focus()
	if exitButton.is_hovered() == true:
		exitButton.grab_focus()

func _on_Button_pressed():
	get_tree().change_scene("res://src/Levels/StageOne.tscn")


func _on_Button2_pressed():
	get_tree().quit()
