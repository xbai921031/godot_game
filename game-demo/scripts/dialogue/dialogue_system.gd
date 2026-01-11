extends Node

signal dialogue_updated(text, choices)

var story_data := {}
var current_node_id := ""

func load_story(path: String) -> void:
    var file := FileAccess.open(path, FileAccess.READ)
    story_data = JSON.parse_string(file.get_as_text())
    current_node_id = story_data["start"]
    _emit_current()

func choose(index: int) -> void:
    var node : Dictionary = story_data["nodes"][current_node_id]
    var choice : Dictionary = node["choices"][index]

    if choice.has("set"):
        for k in choice["set"].keys():
            GameManager.state[k] = GameManager.state.get(k, 0) + choice["set"][k]

            # System log
            if k == "trust_ai":
                if choice["set"][k] > 0:
                    SystemLog.add_log("观察到操作者在关键节点选择依赖预测模型。")
            else:
                SystemLog.add_log("观察到操作者对预测模型持保留态度。")

    current_node_id = choice["next"]
    _emit_current()

func _emit_current() -> void:
    var node : Dictionary = story_data["nodes"][current_node_id]

    if node.has("branches"):
        current_node_id = _evaluate_branches(node["branches"])
        _emit_current()
        return

    emit_signal("dialogue_updated", node["text"], node.get("choices", []))

func _evaluate_branches(branches: Array) -> String:
    for branch in branches:
        if branch.has("if"):
            if _check_condition(branch["if"]):
                return branch["next"]
        elif branch.has("else"):
            return branch["next"]

    return current_node_id

func _check_condition(cond: Dictionary) -> bool:
    for key in cond.keys():
        var rule : Dictionary = cond[key]
        var value : Dictionary = GameManager.state.get(key, 0)

        if rule.has(">=") and value < rule[">="]:
            return false
        if rule.has("<") and value >= rule["<"]:
            return false

    return true
