extends Node2D


var age = 0
var state = "start"


# Called when the node enters the scene tree for the first time.
func _ready():
    if not Global.first:
        queue_free()
    pass # Replace with function body.


func _process(delta):
    age += delta
    match state:
        "start":
            $Label.modulate.a = min(1,age)
            if Input.is_action_just_pressed("click") and age > 2:
                state = "next"
                age = 0
            if age > 10:
                state = "next"
                age = 0
        "next":
            $Label.modulate.a = max(0,1-age)
            if age > 0.5:
                $Label2.modulate.a = min(1,age-0.5)
            if Input.is_action_just_pressed("click") and age > 2:
                state = "fade"
                age = 0
            if age > 10:
                state = "fade"
                age = 0
        "fade":
            $Label2.modulate.a = max(0,1-age)
            if age > 1:
                Global.first = false
                queue_free()
            
                
            
