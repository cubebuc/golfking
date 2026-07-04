extends Camera2D

@export var target: Node2D
@export var follow_speed:= 5


func _physics_process(delta: float) -> void:
	if target:
		var target_pos = target.global_position
		global_position = lerp(global_position, target_pos, delta * follow_speed)
