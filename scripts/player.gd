extends RigidBody2D


@export var power_max: float = 1500
@export var power_speed: float = 1000
@export var angle_speed: float = 1.5

var power: float = 0
var angle: float = 0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_pressed("aim_left"):
		angle -= angle_speed * delta
	if Input.is_action_pressed("aim_right"):
		angle += angle_speed * delta
	angle = clamp(angle, -1.5, 1.5)

	if Input.is_action_pressed("ui_accept"):
		power += power_speed * delta
		power = clamp(power, 0, power_max)
	if Input.is_action_just_released("ui_accept") or power >= power_max:
		self.apply_impulse(Vector2.UP.rotated(angle) * power)
		power = 0
