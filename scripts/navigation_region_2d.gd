extends NavigationRegion2D

signal bake_terrain

func _on_bake_terrain() -> void:
	self.bake_navigation_polygon()
	print("terrain baked")
