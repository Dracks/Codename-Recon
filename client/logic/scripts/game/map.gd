@icon("res://assets/images/icons/layers-outline.svg")
@tool
class_name Map
extends Node2D

const DUPLICATE_TEST_SIZE: int = 4

@export var map_name: String
@export var creator: String
@export var creator_url: String
@export var players: Array[Player]
@export_group("Tool")
@export var test_duplicates: bool:
	set(value):
		_test_for_duplicates()
@export_multiline var duplicate_result: String = ""


func _ready() -> void:
	# TODO workaround for adding nodes to exported typed array
	if not Engine.is_editor_hint():
		for player: Player in $Players.get_children():
			players.append(player)

func _test_for_duplicates() -> void:
	var found_duplicates: bool = false
	duplicate_result = ""
	for child: Node in get_children():
		if is_instance_of(child, Terrain):
			var terrain: Terrain = child as Terrain
			var result: Array[Node] = get_children().filter(func(x: Node) -> bool: 
				var length_squared := ((x as Terrain).global_position - terrain.global_position).length_squared()
				return x != terrain and is_instance_of(x, Terrain)	and length_squared < DUPLICATE_TEST_SIZE)
			for r: Terrain in result:
				duplicate_result += str(r) + "\n"
				found_duplicates = true
	if not found_duplicates:
		duplicate_result = "No duplicates found (%s)" % Time.get_datetime_string_from_system()
