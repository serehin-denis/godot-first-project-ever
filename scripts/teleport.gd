extends Area2D

@export var out: Marker2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and out != null:
		body.global_position = out.global_position
