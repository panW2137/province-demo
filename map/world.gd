extends Node2D

@onready var provinceList = $"province list"

func _ready():
	Globals.selectedProvincePosition = provinceList.get_child(0).global_position
	
	for i in provinceList.get_child_count():
		var province:Province = provinceList.get_child(i)
		await province.giveId(i)
	
	for prov in provinceList.get_children():
		await prov.mouseClicked.connect(_on_province_mouse_clicked)
	
	for prov in provinceList.get_children():
		await prov.findNeighbours(provinceList.get_children())
	
	
	for prov in provinceList.get_children():
		await prov.connectToNeighbours(provinceList.get_children())
	
func _on_province_mouse_clicked(index):
	var province = provinceList.get_child(index)
	var provinceNeighbours = province.neighbours
	
	for prov in provinceList.get_children():
		prov.unhighlight()
	
	province.click()
	
	for neighbour in provinceNeighbours:
		provinceList.get_child(neighbour).highlight()
