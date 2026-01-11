extends Node

var logs: Array[String] = []

func add_log(text: String) -> void:
    logs.append(text)
    print("[SYSTEM LOG] ", text)

func get_logs() -> Array[String]:
    return logs
