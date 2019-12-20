extends Node

var popup
var popup_label

# neccassary interface nodes
var main_window
var side_window
var lower_window
var inventory

var popup_max_duration = 2 # in seconds
var popup_duration = 0

#var dialog = [
#"Witness1:\nBefragen Sie die Leute nach ihren [Alibis]?\nDann muss ich es nicht mehr tun....ich glaube es war [Gift] im Spiel.\nDann halte ich jetzt mal einen ganz langen und sinnfreien Monolog, ich hoffe das stört niemanden. Wenn doch so melden Sie sich bitte irgendwo bei der berechtigten Stelle.\nVom Fenster aus hat man einen schönen Blick auf den [Schlossberg].", 
#"Witness2:\nUm hier mehr zu erfahren müssen Sie schon [Lili] fragen. Da kann ich Ihnen sicher nichts dazu sagen.\nUnd wenn Sie schon dabei sind können Sie doch gleich mal Petersilie aus dem [Garten] holen.",
#"Witness3:\nAlso das war was, das kann ich Ihnen sagen! Da gabs so einen lauten [Knall], das müssen die anderen doch gehört haben!",
#"Witness4:\nDas ist aber ein ganz heikles Thema was Sie da ansprechen! Diese [Hexe] kann mir gestohlen beleiben!"]

var dialog_scene = preload("res://Assets/Interface/Dialog/dialog_scene.tscn")
var witness_scene = preload("res://Assets/Interface/Witness/Witnesses.tscn")

var current_witness
var the_dialog_scene

func _ready():
	# get instances of nodes
	popup = get_node("PopupPanel")
	popup_label = popup.get_node("PopupLabel")
	
	# get instances of neccassary interface nodes
	main_window = get_node("Interface/Screen/Upper/Main")
	side_window = get_node("Interface/Screen/Upper/Side")
	lower_window = get_node("Interface/Screen/Lower")
	
	#dialog = main_window.get_node("Dialog")
	inventory = side_window.get_node("Inventory")
	
	# connect popup signals with popup function
	#dialog.connect("popup", self, "show_popup")
	inventory.connect("popup", self, "show_popup")
	
	# connect signals threw nodes
	#dialog.connect("try_learn_word", inventory, "_on_Dialog_try_learn_word")

func start_dialog(witness_data):
	#print_debug("Got: " + dialog[0])	
	#print_debug(dialog[1])
	var name = witness_data["name"]
	current_witness = witness_data[name]	# witness_data[witness_data["name"]] all dialog objects this is ugly
	current_witness["name"] = name # uglyyyyyyy
	var data = current_witness[""] # default dialog object
	print_debug(data)
	# remove the witness overview
	var witness = main_window.get_node("Witness")
	main_window.remove_child(witness)
	
	# create a dialog scene
	the_dialog_scene = dialog_scene.instance()
	_update_dialog(data)
	
	
	# connect signals from new scene
	the_dialog_scene.connect("try_learn_word", inventory, "_on_Dialog_try_learn_word")
	the_dialog_scene.get_node("VBoxContainer/BackButton").connect("pressed", self, "_on_BackButton")
	
	# add the new secene to the main window
	main_window.add_child(the_dialog_scene)	

func change_dialog(word):
	if current_witness != null and current_witness.has(word):
		_update_dialog(current_witness[word])

func _update_dialog(dialog_data):
	print_debug(dialog_data.keywords_text)
	the_dialog_scene._set_keywords(dialog_data.keywords_text)
	# TODO set keywords_inventory (and learn keywords_inventory instead of keywords_text)
	
	
	var text = dialog_data.dialog_text[0]
	# add [ ] around keywords in text
	for w in dialog_data.keywords_text:
		var i = text.find(w)
		print_debug(i)
		text = text.insert(i, "[")
		text = text.insert(i + 1 + w.length(), "]")
	text = current_witness.name + ":\n" + text
	var dialog_box = the_dialog_scene.get_node("VBoxContainer/DialogBox")
	dialog_box.set_text(text)
	
func _process(delta):
	# if a timer for the popup is set, wait until it's finished and close the popup then
	if popup_duration < 0:
		popup.hide()
	else:
		popup_duration -= delta
		

# get input mostly from signals
## set the label text to given one and shows the popup
## in the center of the screen for the time of popup_max_duration
func show_popup(text):
	popup_label.text = text
	popup_duration = popup_max_duration
	popup.popup_centered()
	
func _on_BackButton():
	var dialog_node = main_window.get_node("Dialog")
	main_window.remove_child(dialog_node)
	the_dialog_scene = null
	
	var new_witness_scene = witness_scene.instance()
	new_witness_scene.name = "Witness"
	main_window.add_child(new_witness_scene)
	current_witness = null
