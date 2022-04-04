extends Node2D

var state = "wait"

export(PackedScene) var GameView

func _ready():
    $CanvasLayer/Menu.modulate.a = 0
    state = "ready"
var age = 0
var part_age = 0
var game = false

func _process(delta):
    part_age += delta
    $Particles2D.position.x = 500+ sin(part_age/3.0)*40
    if state == "wait":
        return
    age += delta
    if state == "ready":
        age += delta
        if age > 0.2:
            if Input.is_action_just_pressed("click"):
                state = "animate"
                age = 0
                $Music.play()
    if state == "animate":
        $Logo.modulate.a = max(0, 1-age*3)    
        $Scale.frame = min(floor(age*10),8)
        if age > 1:
            $Smallogo.modulate.a = min(1, age-1)
        
        if age > 1.2:
            $CanvasLayer/Menu.show()
            $CanvasLayer/Menu.modulate.a = min(1, age-1.2)
        if age > 2.2:
            state = "menu"
    if Input.is_action_just_pressed("ui_cancel"):
        if game:
            game.queue_free()
            $CanvasLayer/Menu.show()
            game = false
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
            $Music.play()
            $sfx.play()
            $CanvasLayer/Menu.show()
            show()
             
            




func _on_StartGame_pressed():
    state = "menu"
    hide()
    $CanvasLayer/Menu.hide()
    $CanvasLayer/Menu.modulate.a = 1
    $CanvasLayer/Menu.hide()
    $Smallogo.modulate.a = 1
    $Scale.frame = 8
    $Logo.modulate.a = 0
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    game = GameView.instance()
    add_child(game)
    $Music.stop()
    $sfx.stop()
    $MusicLoop.stop()
    


func _on_Music_finished():
    if not game:
        $MusicLoop.play()

func restart_lvl():
    if game:
        game.queue_free()
        $Timer.start()
    
func start_lvl():
    game = GameView.instance()
    add_child(game)


func _on_Timer_timeout():
    start_lvl()


func _on_FullScreen_toggled(button_pressed):
    OS.window_fullscreen = button_pressed
