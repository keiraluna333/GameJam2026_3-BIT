extends StaticBody2D

@export var wind_length: float = 16.0
@export var default_wind_speed: float = 10.0
@onready var collision_shape: CollisionShape2D = $wind_zone/wind_coll
@onready var particles: GPUParticles2D = $wind_zone/GPUParticles2D
var bodies_in_wind = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_wind_zone()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$fan_sprite.speed_scale = GameManager.time_scale
	update_particles()
	for body in bodies_in_wind:
		if "wind_velocity" in body:
			var direction = -global_transform.x
			var push = default_wind_speed * GameManager.time_scale
			body.wind_velocity = push * direction
			
	
func _on_wind_zone_body_entered(body: Node2D) -> void:
	if not bodies_in_wind.has(body):
		bodies_in_wind.append(body)

func _on_wind_zone_body_exited(body: Node2D) -> void:
	bodies_in_wind.erase(body)
	if "wind_velocity" in body:
		body.wind_velocity = Vector2(0,0)
		
func update_wind_zone():
	if collision_shape and collision_shape.shape is RectangleShape2D:
		var rect = collision_shape.shape as RectangleShape2D
		rect.size = Vector2(wind_length, 32.0) 
		$wind_zone.position = Vector2(-wind_length / 2.0, 0)
		
func update_particles():
	if particles:
		particles.position = Vector2(wind_length / 2.0, 0)
		var mat = particles.process_material as ParticleProcessMaterial
		particles.local_coords = true
		
		if mat:
			particles.lifetime = 2
			mat.initial_velocity_min = 8 * default_wind_speed * GameManager.time_scale
			mat.initial_velocity_max = mat.initial_velocity_min
			
			if not mat.color_ramp:
				var gradient_texture = GradientTexture1D.new()
				var gradient = Gradient.new()
				gradient.offsets = [0.0, 0.85, 1.0]
				gradient.colors = [Color(1, 1, 1, 0.7), Color(1, 1, 1, 0.7), Color(1, 1, 1, 0.0)]
				
				gradient_texture.gradient = gradient
				mat.color_ramp = gradient_texture
