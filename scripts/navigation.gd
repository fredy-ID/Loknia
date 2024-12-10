extends Node2D

# Basic query for a navigation path using the default navigation map.

func get_navigation_path(p_start_position: Vector2, p_target_position: Vector2) -> PackedVector2Array:
	if not is_inside_tree():
		return PackedVector2Array()

	var default_map_rid: RID = get_world_2d().get_navigation_map()
	var path: PackedVector2Array = NavigationServer2D.map_get_path(
		default_map_rid,
		p_start_position,
		p_target_position,
		true
	)
	return path
