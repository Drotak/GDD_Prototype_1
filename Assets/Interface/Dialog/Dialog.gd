extends PanelContainer

export var keywords = ["Alibi", "Gift", "Schlossberg"] setget _set_keywords

var dialog_box

signal try_learn_word(word)
signal popup(text)

# Called when the node enters the scene tree for the first time.
func _ready():
	#.add_keyword_color("Alibi", Color(0, 200, 200, 100))
	#.add_color_region("]", "", Color(0, 150, 200, 100))
	dialog_box = get_node("VBoxContainer/DialogBox")
	dialog_box.add_color_region("[", "]", Color(0, 150, 200, 100))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	null

func _set_keywords(new_keywords):
	keywords = new_keywords
	update()

func extract_learnable_word(input):
	if input != null && input != "":
		for k in keywords:
			#if input.begins_with(k): # TODO better match with substring instead
			if k in input:
				return k
		print_debug("could not find " + input +  " in keywords")  
		

func learn_word():
	var word = extract_learnable_word(dialog_box.get_word_under_cursor())
	if word != null:
		emit_signal("try_learn_word", word)