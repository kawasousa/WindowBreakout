extends Node

var player := CharacterBody2D.new()
var playerCollision := CollisionShape2D.new()
var isBallTouched: bool = false
var ball := Area2D.new()
var ballCollision := CollisionShape2D.new()
var ballSpeedY: int = 5
var ballSpeedX: int
var maxSpeedX: int = 5
var playerPointsLabel := Label.new()
var playerPoints: int = 0

#################################

func _ready():
	addPlayer()
	addBall()
	addPointsLabel()
	spawnBlock()

func _process(delta):
	controlPlayer(delta)
	ballMovement()
	showPlayerPoints()

##Adiciona o player e suas caracteristicas ao jogo
func addPlayer() -> void:
	player.global_position.y = get_viewport().size.y - 30
	player.global_position.x = get_viewport().size.x / 2
	add_child(player)
	
	#Adiciona colisão ao player
	var collisionShape = RectangleShape2D.new()
	collisionShape.size = Vector2(100,25)
	playerCollision.set_shape(collisionShape)
	playerCollision.set_debug_color(Color(0,0,0.5,1))
	player.add_child(playerCollision)

##Controla a movimentação lateral do player
func controlPlayer(delta) -> void:
	player.global_position.x = clamp(player.global_position.x, 75, get_viewport().size.x - 75)
	var playerDirection = Input.get_axis("ui_left", "ui_right")
	var playerSpeed: int = 800
	player.global_position.x += playerDirection * playerSpeed * delta

##Adiciona a ball ao jogo
func addBall() -> void:
	ball.global_position = player.global_position - Vector2(0,300)
	add_child(ball)
	
	#Adiciona a colisão à ball
	var collisionShape = CircleShape2D.new()
	collisionShape.radius = 10
	ballCollision.set_shape(collisionShape)
	ballCollision.set_debug_color(Color(0.5,0.5,0,1))
	ball.add_child(ballCollision)
	
	ball.connect("body_entered", detectBallCollision)

##Controla o movimento da bola
func ballMovement() -> void:
	var viewportLimit = get_viewport().size.x
	var ballPosition = ball.global_position
	ball.global_position.x = clamp(ball.global_position.x, 0, viewportLimit)
	ball.global_position.y += ballSpeedY
	if isBallTouched:
		ball.global_position.x += ballSpeedX
	else:
		ball.global_position.x += 0
	
	if ballPosition.x <= 0:
		ballSpeedX = maxSpeedX
	elif ballPosition.x >= viewportLimit:
		ballSpeedX = -maxSpeedX

##Inverte a velocidade y da ball quando ela bate no player
func detectBallCollision(body) -> void:
	if body == player:
		ballSpeedY *= -1
		isBallTouched = true
		if body.global_position.x - ball.global_position.x < -10:
			ballSpeedX = maxSpeedX
		else:
			ballSpeedX = -maxSpeedX
	if body.is_in_group("Blocks"):
		ballSpeedY *= -1
		body.queue_free()
		playerPoints += 10

##Adiciona os pontos da partida ao HUD do jogo
func addPointsLabel() -> void:
	playerPointsLabel.global_position = Vector2(10,10)
	add_child(playerPointsLabel)

##Atualiza os pontos do jogador no HUD
func showPlayerPoints() -> void:
	playerPointsLabel.text = str(playerPoints)

##Adiciona uma camada de blocos no nível
func spawnBlock() -> void:
	var blockGroup := Node2D.new()
	add_child(blockGroup)
	var _lastBlockPosition = 0
	for _cell in range(10):
		var block := StaticBody2D.new()
		var _blockCollision := CollisionShape2D.new()
		var _collisionShape := RectangleShape2D.new()
		_collisionShape.size = Vector2(100,25)
		_blockCollision.set_shape(_collisionShape)
		var collisionColor = randf_range(0,1)
		_blockCollision.set_debug_color(Color(0,collisionColor,0,0.5))
		_blockCollision.global_position.x = _lastBlockPosition
		_lastBlockPosition += 125
		block.add_child(_blockCollision)
		blockGroup.add_child(block)
		block.add_to_group("Blocks")

