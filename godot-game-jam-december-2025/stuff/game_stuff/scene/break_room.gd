extends Node2D

signal exit_break_room;

func _on_exit_room_pressed() -> void:
	exit_break_room.emit();
