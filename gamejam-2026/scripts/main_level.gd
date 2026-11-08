extends Node2D

@onready var p1: CharacterBody2D = $player_1
@onready var p2: CharacterBody2D = $player_2
@onready var p1_spawns_container: Node2D = $p1_spawns
@onready var p2_spawns_container: Node2D = $p2_spawns
@onready var portals_container: Node2D = $portals
@onready var button_container = $buttons 
@onready var laser_container = $lasers
@onready var camera: Camera2D = $Camera2D
@onready var heart1: AnimatedSprite2D = $heart1
@onready var heart2: AnimatedSprite2D = $heart2
@export var p1_spawn_points: Array[Marker2D] = []
@export var p2_spawn_points: Array[Marker2D] = []

var p1_current_spawn
var p2_current_spawn
var spawn_index: int = 0
var current_dist
var distance
var offset: float = 8.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heart1.visible = false
	heart2.visible = false
	$sunset.visible = false
	$ending.visible = false
	current_dist = (p1.position).distance_to(p2.position)
	for child in p1_spawns_container.get_children():
		if child is Marker2D:
			p1_spawn_points.append(child)

	for child in p2_spawns_container.get_children():
		if child is Marker2D:
			p2_spawn_points.append(child)
			
	for child in portals_container.get_children():
		child.teleporting.connect(_on_teleport_teleporting)
	
	for child in button_container.get_children():
		if child.has_signal("button_pressed"):
			child.button_pressed.connect(_on_any_button_pressed)
	
	p1_current_spawn = p1_spawn_points[spawn_index].position
	p2_current_spawn = p2_spawn_points[spawn_index].position
	spawn_players()
	if p1:
		p1.died.connect(_on_player_died)
	if p2:
		p2.died.connect(_on_player_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	distance = (p1.position).distance_to(p2.position)

	if distance != current_dist:
		current_dist = distance
		GameManager.time_scale = -0.015 * current_dist + 4
		GameManager.change_time()
	
	if Input.is_action_just_pressed("restart"):
		spawn_players()
	
func spawn_players(p1_loc=p1_current_spawn, p2_loc=p2_current_spawn):
	p1.position = p1_loc + Vector2(offset,0)
	p2.position = p2_loc + Vector2(-offset,0)
	
func _on_player_died():
	Engine.time_scale = 0.0
	var timer = get_tree().create_timer(0.2, true, false, true)
	await timer.timeout
	Engine.time_scale = 1.0
	spawn_players()
	
func _on_teleport_teleporting():
	spawn_index += 1
	for laser in laser_container.get_children():
		laser.turn_on()
	if spawn_index == 5:
		camera.position = Vector2(0, -184.0)
	else:
		camera.position.x += 320
		
	p1_current_spawn = p1_spawn_points[spawn_index].position
	p2_current_spawn = p2_spawn_points[spawn_index].position
	spawn_players()
	p1.appear()
	p2.appear()

func _on_any_button_pressed():
	for laser in laser_container.get_children():
		laser.turn_off()

func _on_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		heart1.visible = true
		heart2.visible = true
		heart1.play("default")
		heart2.play("default")
		$ending_timer.start()

func _on_ending_timer_timeout() -> void:
	$AnimationPlayer.play("ending")
	$sunset.visible = true
	$ending.visible = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
