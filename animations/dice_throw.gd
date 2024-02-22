extends Sprite2D


var animation_repeats_counter: int = 0
var dice: int = 0

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d_3: GPUParticles2D = $GPUParticles2D3
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2
@onready var timer: Timer = $Timer


func _ready() -> void:
	randomize()
	dice = randi_range(1,6)
	
	Events.skip_dicethrow.connect(_on_dicethrow_skipped.bind())
	timer.start()
	
	


func _on_timer_timeout() -> void:
	timer.stop()
	
	if animation_repeats_counter == 25:
		frame = dice - 1
		emit_particles()
	else:
		var y: int = randi_range(1,6)
		frame = y - 1
		animation_repeats_counter += 1
		var time: float = calculate_new_timer(animation_repeats_counter)
		
		timer.wait_time = time
		timer.start()


func calculate_new_timer(counter: int) -> float:
	if counter < 16:
		return 0.07
	else:
		var new_timer: float = clamp(0.07 + ((counter - 15) * 0.05), 0.07, 0.5)
		return new_timer


func emit_particles() -> void:
	gpu_particles_2d.emitting = true
	gpu_particles_2d_2.emitting = true
	gpu_particles_2d_3.emitting = true


func _on_dicethrow_skipped() -> void:
	timer.stop()
	queue_free()


func _on_tree_exiting() -> void:
	Events.emit_signal("send_dice_throw_result", dice)
