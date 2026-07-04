extends RigidBody2D


@export var power_max: float = 1500
@export var power_speed: float = 1000
@export var angle_speed: float = 1.5

@export var initial_movement_threshold: float = 12.0
@export var movement_threshold: float = 15.0

var power: float = 0
var angle: float = 0
var is_stationary = false
var _was_stationary = false

@onready var charge_progress_bar = $Visual/TextureProgressBar
@onready var visual = $Visual
@onready var arrow_sprite = $Visual/ArrowSprite
@onready var debug_player_linear_velocity_size = %DebugPlayerLinearVelocitySize



func _process(delta: float) -> void:
	visual.rotation = - self.rotation
	arrow_sprite.rotation = angle

	charge_progress_bar.value = power / power_max * 100

	if Input.is_action_pressed("left"):
		angle -= angle_speed * delta
	if Input.is_action_pressed("right"):
		angle += angle_speed * delta
	angle = clamp(angle, -1.5, 1.5)

	_was_stationary = is_stationary
	if debug_player_linear_velocity_size:
		debug_player_linear_velocity_size.text = "Linear velicity length: " + str(floor(linear_velocity.length()))
	
	if _was_stationary:
		is_stationary = linear_velocity.length() < movement_threshold
	else:
		is_stationary = linear_velocity.length() < initial_movement_threshold
	
	if not is_stationary: 
		power = 0
		return
	if Input.is_action_pressed("launch"):
		power += power_speed * delta
		power = clamp(power, 0, power_max)
	if Input.is_action_just_released("launch") or power >= power_max:
		self.apply_impulse(Vector2.UP.rotated(angle) * power)
		power = 0
