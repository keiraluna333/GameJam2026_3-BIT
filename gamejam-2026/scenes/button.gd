extends Node2D

signal button_pressed
@onready var anim_sprite: AnimatedSprite2D = $StaticBody2D/AnimatedSprite2D
@onready var button_coll: CollisionShape2D = $button_area/CollisionShape2D

var pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_area_body_entered(body: Node2D) -> void:
	print("pressed")
	if body.is_in_group("players"):
		if !pressed:
			anim_sprite.play("pressed")
			button_pressed.emit()
