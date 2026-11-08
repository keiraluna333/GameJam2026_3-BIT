extends CharacterBody2D

var wind_velocity
signal died

func _ready() -> void:
	wind_velocity = Vector2(0,0)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * delta) * 0.3
		$AnimatedSprite2D.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("p1_up") and is_on_floor():
		velocity.y = GameManager.player_jump_vel

	var direction := Input.get_axis("p1_left", "p1_right")
	if direction:
		velocity.x = direction * GameManager.player_speed
		
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, GameManager.player_speed)
		$AnimatedSprite2D.play("default")
	
	velocity += wind_velocity

	move_and_slide()
	
func die():
	velocity = Vector2.ZERO
	died.emit()
	
func disappear():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)

func appear():
	show()
	$CollisionShape2D.set_deferred("disabled", false)
	set_physics_process(true)
