extends VBoxContainer

var delete_button
var ask_button
var inventory_title
var inventory_list
var inventory = []
export(int) var MAX_WORDS = 2

signal popup(text)
signal ask_dialog(word)

func _ready():
	inventory_title = get_node("Titel/TitelLabel")
	inventory_list = get_node("ItemList")
	delete_button = get_node("DeleteButton")
	delete_button.connect("button_up", self, "remove_item")
	ask_button = get_node("AskButton")
	ask_button.connect("button_up", self, "ask_witness")
	var root = get_tree().get_root().get_node("Game")
	self.connect("ask_dialog", root, "change_dialog")

func update_inventory_title():
	inventory_title.text = "Inventar (" + str(inventory.size()) + "/" + str(MAX_WORDS) + ")"

# removes an item from the inventory
func remove_item():
	var items = inventory_list.get_selected_items()
	# only do something if there are items in the list
	if items.size() > 0:
		var item_text = inventory_list.get_item_text(items[0])
		
		# remove the item from the inventory, if its found
		if item_text in inventory:
			inventory.erase(item_text)
			inventory_list.remove_item(items[0])
			update_inventory_title()
			
			if inventory.empty():
				delete_button.set_disabled(true)
				ask_button.set_disabled(true)

# add word to player inventory if possible, otherwise emit popup signal
func _on_Dialog_try_learn_word(word):
	if inventory.has(word):
		emit_signal("popup", "Das Wort \"" + word + "\" ist bereits in deinem Inventar!")
	elif inventory.size() < MAX_WORDS:
		if inventory.empty():
			delete_button.set_disabled(false)
			ask_button.set_disabled(false)
		inventory.append(word)
		inventory_list.add_item(word)
		update_inventory_title()
	else:
		emit_signal("popup", "Dein Inventar ist voll!")

func ask_witness():
	var items = inventory_list.get_selected_items()
	# only do something if there are items in the list
	if items.size() > 0:
		var item_text = inventory_list.get_item_text(items[0])
		if item_text in inventory:
			#print("ask " + item_text) 
			emit_signal("ask_dialog", item_text)