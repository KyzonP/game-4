extends AudioStreamPlayer

func _ready():
	get_parent().button_down.connect(_playSound)

func _playSound():
	play()
