@tool
extends AnimationPlayer

@export_node_path(Slider) var slider_node
@export_range(0, 1) var target_position: float:
	get:
		return get_target_position()
	set(value):
		set_target_position(value)
@export var proxity_factor = 0.03
@export var animation_name = ""

var anim_target_position = 0.0
var anim_current_position = 0.0
var anim_playing_forward = true
var slider

func _ready():
	if animation_name.is_empty() and get_animation_list().size() > 0:
		animation_name = get_animation_list()[0]
	if slider_node:
		slider = get_node(slider_node)
		slider.value_changed.connect(_on_slider_value_changed)
	if animation_name.is_empty():
		set_process(false)
	else:
		play(animation_name)
		seek(anim_target_position * current_animation_length, true)


func _on_slider_value_changed(_value):
	anim_target_position = slider.ratio


func set_target_position(pos):
	anim_target_position = clamp(pos, 0, 1)


func get_target_position():
	return anim_target_position


func _process(_delta):
	if is_playing():
		anim_current_position = current_animation_position / current_animation_length
	# Check for closeness to target position
	if abs(anim_target_position - anim_current_position) < proxity_factor:
		if is_playing():
			stop(false)
	else:
		if anim_target_position > anim_current_position:
			# Play forward to advance towards the target position
			if not is_playing() or not anim_playing_forward:
				play(animation_name)
			anim_playing_forward = true
		else:
			# Play backwards to move back towards the target position
			if not is_playing() or anim_playing_forward:
				play_backwards(animation_name)
			anim_playing_forward = false
