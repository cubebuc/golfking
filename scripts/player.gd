extends RigidBody2D


@export var power_max: float = 1500
@export var power_speed: float = 1000
@export var angle_speed: float = 1.5

@export var initial_movement_threshold: float = 5.0
@export var movement_threshold: float = 200.0

@export var material_damp: Dictionary = {
	"Stone": 4,
	"Sand": 18
}

var power: float = 0
var angle: float = 0
var is_still = false
var _was_stationary = false

@onready var charge_progress_bar = $Visual/TextureProgressBar
@onready var visual = $Visual
@onready var arrow_sprite = $Visual/ArrowSprite
@onready var ground_ray = $Visual/RayCast2D

@onready var debug_ui = %DebugUI


func _process(delta: float) -> void:
	visual.rotation = - self.rotation
	arrow_sprite.rotation = angle

	charge_progress_bar.value = power / power_max * 100

	if Input.is_action_pressed("left"):
		angle -= angle_speed * delta
	if Input.is_action_pressed("right"):
		angle += angle_speed * delta
	angle = clamp(angle, -1.5, 1.5)
	
	_was_stationary = is_still
	var velocity_length_squared = linear_velocity.length_squared()
	if debug_ui:
		debug_ui.player_linear_velocity_size.text = "Linear velicity length: " + str(floor(velocity_length_squared))
		#print(floor(velocity_length_squared))
	
	if _was_stationary:
		is_still = velocity_length_squared < movement_threshold
	else:
		is_still = velocity_length_squared < initial_movement_threshold
	
	if not is_still: 
		power = 0
		return
	if Input.is_action_pressed("launch"):
		power += power_speed * delta
		power = clamp(power, 0, power_max)
	if Input.is_action_just_released("launch") or power >= power_max:
		self.apply_impulse(Vector2.UP.rotated(angle) * power)
		power = 0


func _on_body_entered(body: Node) -> void:
	if body is TileMapLayer:
		var tilemap: TileMapLayer = body
		var point = ground_ray.get_collision_point()
		var nudged_point = point + Vector2.DOWN * 5
		var map_coords = tilemap.local_to_map(nudged_point)
		var data = tilemap.get_cell_tile_data(map_coords)
		if data:
			var material = data.get_custom_data("Material")
			if debug_ui:
				debug_ui.player_debug_material.text = "material: " + material
			self.angular_damp = material_damp[material]
