extends Polygon2D
class_name Province


@onready var colPolygon = $hitbox/CollisionPolygon2D
@onready var border = $border
@onready var idText = $id
@onready var animation = $AnimationPlayer
@onready var navMesh = $NavigationRegion2D

var id:int = 0
var neighbours:Array[int]

signal mouseEntered(index)
signal mouseExited(index)
signal mouseClicked(index)

func _ready():
	#collision
	colPolygon.polygon = polygon
	
	#navigation
	#var navMeshPolygon:NavigationPolygon = NavigationPolygon.new()
	#var outline = polygon
	#navMeshPolygon.add_outline(outline)
	#navMeshPolygon.make_polygons_from_outlines()
	#navMesh.navigation_polygon = navMeshPolygon
	
	#border
	#idk why it doesn't work wihout this
	var borderPoints:PackedVector2Array = polygon
	borderPoints.push_back(polygon[0])
	
	border.points = borderPoints

func giveId(newId:int):
	id = newId
	idText.text = str(newId)
	
func connectToNeighbours(allProvinces:Array):
	for i in neighbours:
		var nei = allProvinces[i]
		var line:Line2D = Line2D.new()
		var link:NavigationLink2D = NavigationLink2D.new()
		
		line.add_point(Vector2.ZERO)
		line.width = 1
		line.default_color = Color(1,0,0)
		link.end_position = nei.global_position - global_position
		line.add_point(link.end_position)
		add_child(link)
		add_child(line)

func findNeighbours(allProvinces:Array):
	#for every province
	#check if this is you
	#check every your polygon
	#if it matches any of provinces polygons
	#if if two polygons matches, it's neighbour
	
	#loops over every province in list
	
	for province in allProvinces:
		#cheks if this is you
		if province.polygon == polygon:
			continue
		else:
			var matches = 0
			#loops over every point of your polygon
			for yourPoint in polygon:
				#loops over every point of foreign polygon
				for foreignPoint in province.polygon:
					#points coords are local, not global
					#not knowing this coused me a loot of headache
					if global_position + yourPoint == province.global_position + foreignPoint:
						matches += 1
			if matches >= 2:
				neighbours.push_back(province.id)
				
	#this took way longer than i wanted to
	#but SOMEHOW it works

func _on_hitbox_mouse_entered():
	emit_signal("mouseEntered",id)

func _on_hitbox_mouse_exited():
	emit_signal("mouseExited",id)

#thank you again chatGPT
func _on_hitbox_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("mouseClicked",id)
			Globals.selectedProvinceId = id
			Globals.selectedProvincePosition = global_position

func highlight():
	color = Color(0.5,0.5,1)

func unhighlight():
	color = Color(0.5,0.5,0.5)

func click():
	color = Color(1,0.5,0.5)
