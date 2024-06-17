extends Node

var player: ColorRect = ColorRect.new()
var playerCollision: CollisionShape2D = CollisionShape2D.new()


func _ready():
	addPlayer()

func _process(delta):
	controlPlayer(delta)

##Adiciona o player e suas caracteristicas ao jogo
func addPlayer() -> void:
	player.color = Color(0.5,0.5,1,1)
	player.size = Vector2(100,25)
	player.global_position.y = get_viewport().size.y - 30
	player.global_position.x = get_viewport().size.x / 2
	add_child(player)
	
	#Adiciona colisão ao player
	var collisionShape = RectangleShape2D.new()
	collisionShape.size = player.size
	playerCollision.set_shape(collisionShape)
	playerCollision.position = Vector2(50,12)
	player.add_child(playerCollision)

##Controla a movimentação lateral do player
func controlPlayer(delta) -> void:
	player.global_position.x = clamp(player.global_position.x, 25, get_viewport().size.x - 125)
	var playerDirection = Input.get_axis("ui_left", "ui_right")
	var playerSpeed: int = 800
	player.global_position.x += playerDirection * playerSpeed * delta
