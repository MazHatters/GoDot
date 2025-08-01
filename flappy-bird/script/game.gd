extends Node

@export var pipe_scene : PackedScene

var game_running : bool			# <- To check game state
var game_over : bool				# <- To check game state
var scroll						# <- Technically for parallax effect
var score						# <- To track score
const SCROLL_SPEED : int = 4		# <- To adjust game speed
var screen_size : Vector2i		#
var ground_height : int			#
var pipes : Array				# <- To store all the pipes created
const PIPE_DELAY : int = 100		# <- To control how long until next pipe
const PIPE_RANGE : int = 200		# <- To control position of pipes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	pipes.clear()
	generate_pipes()
	$Bird.reset()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						check_top()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PipeTimer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if game_running:
		scroll += SCROLL_SPEED
		# Reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		# Move ground node
		$Ground.position.x = -scroll
		# Move pipes
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout() -> void:
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$Bird.flying = false
	game_running = false
	game_over = true

func bird_hit():
	$Bird.falling = true
	stop_game()


func _on_ground_hit():
	$Bird.falling = false
	stop_game()
