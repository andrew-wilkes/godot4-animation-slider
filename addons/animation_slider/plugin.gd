@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("AnimationSlider", "AnimationPlayer", preload("animation_slider.gd"), preload("AnimationSlider.svg"))


func _exit_tree():
	remove_custom_type("AnimationSlider")
