extends Node2D

@onready var sprite: Sprite2D = $beam
@onready var area: Area2D = $Area2D
@onready var laser_coll: CollisionShape2D = $Area2D/CollisionShape2D
@onready var anim: AnimationPlayer = $AnimationPlayer

@export var length: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if laser_coll.shape:
		laser_coll.shape = laser_coll.shape.duplicate()
	
	var laser_length: float = sprite.texture.get_width() / sprite.hframes
	var laser_height: float = sprite.region_rect.size.y
	var total_length = laser_length + length
	
	sprite.region_rect.size = Vector2(total_length*4, sprite.texture.get_height())
	laser_coll.shape.size = Vector2(total_length, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	anim.speed_scale = GameManager.time_scale/2
	
func turn_off():
	area.monitoring = false
	sprite.visible = false

func turn_on():
	area.monitoring = true
	sprite.visible = true
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()
