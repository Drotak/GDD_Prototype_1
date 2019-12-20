extends Button

# TODO for json from internet: And remember to go to Export, then the resources tab and set the export mode to Export all resources in the project to make godot include the JSON file in the build

signal start_dialog(witness_data)

var witness =  {}
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_on_Witness_pressed")
	var root = get_tree().get_root().get_node("Game")
	#self.add_user_signal("dialog")
	self.connect("start_dialog", root, "start_dialog")
	#add_user_signal("dialog") --> same as declaration on top
	#self.connect("dialog", self, "test")
	loadJson()

func loadJson():
	var jsonfile = get_node("json").text
	var file = File.new()
	file.open("res://Assets/Dialogs/" + jsonfile, file.READ)
	var text = file.get_as_text()
	witness = parse_json(text)
	file.close()
	#print(witness["name"])
	

func _on_Witness_pressed():
	print(witness[witness["name"]][""].dialog_text[0])
	var name = witness["name"]
	var dialog = witness[witness["name"]][""]
	emit_signal("start_dialog", witness)