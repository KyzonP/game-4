extends Sprite2D

@export var startX : float
@export var endX : float

func bulletChange(amount):
	if amount == 0:
		bulletTween($Bullet3, "fire")
		bulletTween($Bullet2, "fire")
		bulletTween($Bullet1, "fire")
	elif amount == 1:
		bulletTween($Bullet3, "fire")
		bulletTween($Bullet2, "fire")
		bulletTween($Bullet1, "reload")
	elif amount == 2:
		bulletTween($Bullet3, "fire")
		bulletTween($Bullet2, "reload")
		bulletTween($Bullet1, "reload")
	elif amount == 3:
		bulletTween($Bullet3, "reload")
		bulletTween($Bullet2, "reload")
		bulletTween($Bullet1, "reload")
		
func bulletTween(bullet, type):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	if type == "fire":
		tween.tween_property(bullet, "position:x", endX, 1.0)
	elif type == "reload":
		tween.tween_property(bullet, "position:x", startX, 1.0)
