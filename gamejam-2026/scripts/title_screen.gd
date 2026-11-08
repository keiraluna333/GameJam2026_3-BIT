extends MarginContainer

var cutscene: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if "modulate" in self:
		self.modulate.a = 1.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cutscene == 1:
		$VBoxContainer.self_modulate.a = $fade_timer.time_left
		$background.self_modulate.a = $fade_timer.time_left
		$VBoxContainer/HBoxContainer/start.self_modulate.a =  $fade_timer.time_left
		$VBoxContainer/HBoxContainer/quit.self_modulate.a =  $fade_timer.time_left
	elif cutscene == 2:
		$VBoxContainer.self_modulate.a = 0
		$background.self_modulate.a = 0
		$VBoxContainer/HBoxContainer/start.self_modulate.a = 0
		$VBoxContainer/HBoxContainer/quit.self_modulate.a = 0
		$text1.self_modulate.a =  $fade_timer.time_left
	elif cutscene == 3:
		$text1.self_modulate.a =  0
		$text2.self_modulate.a =  $fade_timer.time_left
	elif cutscene == 4:
		$text2.self_modulate.a = 0
		$text3.self_modulate.a = $fade_timer.time_left
	elif cutscene == 5:
		$text3.self_modulate.a = 0
		$text4.self_modulate.a = $fade_timer.time_left
	elif cutscene == 6:
		$text4.self_modulate.a = 0
		$text5.self_modulate.a = $fade_timer.time_left
	elif cutscene == 7:
		$text5.self_modulate.a = 0
		$text6.self_modulate.a = $fade_timer.time_left
	elif cutscene == 8:
		get_tree().change_scene_to_file("res://scenes/main_level.tscn")

func _on_start_pressed() -> void:
	$fade_timer.start()
	cutscene = 1

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	$text_timer.start()
	cutscene += 1

func _on_text_timer_timeout() -> void:
	$fade_timer.start()
