extends Area2D

signal teleporting

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var p1_in: bool = false
var p2_in: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	anim_sprite.speed_scale = GameManager.time_scale

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player_1" and !p1_in:
		p1_in = true
	elif body.name == "player_2" and !p2_in:
		p2_in = true
	if p1_in and p2_in:
		p1_in = false
		p2_in = false
		teleporting.emit()
		set_deferred("monitoring", false)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player_1":
		p1_in = false
	elif body.name == "player_2":
		p2_in = false
