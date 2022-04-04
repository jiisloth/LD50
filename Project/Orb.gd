extends RigidBody

func _ready():
    $AudioStreamPlayer3D.play()

var age = 0
func _process(delta):
    age += delta
    $Inner.scale = Vector3.ONE * (1 + sin(age)*0.8)
    if transform.origin.y < -2:
        queue_free()
    


func _on_Area_body_entered(body):
    if body.is_in_group("Player"):
        if $Particles.emitting:
            body.orb_get()
            queue_free()


func _on_Timer_timeout():
    if $Particles.emitting:
        $MeshInstance.hide()
        $Inner.hide()
        $Particles.emitting = false
        $Particles2.emitting = false
        $AudioStreamPlayer3D.stop()
        $Timer.start(1)
        $Disapear.pitch_scale = 0.8+randf()*0.2
        $Disapear.play()
    else:
        queue_free()
