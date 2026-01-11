extends Control

@onready var dialogue_ui = $DialogueUI
@onready var dialogue_system = $DialogueSystem

func _ready():
    dialogue_system.dialogue_updated.connect(dialogue_ui.update_ui)
    dialogue_system.load_story("res://data/story/story.json")
