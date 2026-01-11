extends Control

@onready var text_label = $TextLabel
@onready var choices_box = $ChoicesBox

func update_ui(text, choices):
    text_label.text = text

    for child in choices_box.get_children():
        child.queue_free()

    for i in range(choices.size()):
        var btn = Button.new()
        btn.text = choices[i]["text"]
        btn.pressed.connect(func():
            $".."/DialogueSystem.choose(i)
        )
        choices_box.add_child(btn)
