extends ViewportContainer


var dead = 0
var alive = 0

func _process(delta):
    var players = get_tree().get_nodes_in_group("Player")
    if len(players) > 0:
        if players[0].dead:
            if dead == 0:
                if has_node("Guide"):
                    $Guide.queue_free()
                $AudioStreamPlayer.play()
                set_text()
                material.set_shader_param("tint_mix", 1.0)
            dead += delta
            if dead > 1:
                $you_dead_text.modulate.a = (dead-1)/4.0
            if dead > 5:
                if Input.is_action_just_pressed("jump"):
                    if get_parent().get_parent().has_method("restart_lvl"):
                        get_parent().get_parent().restart_lvl()
                    else:
                        get_tree().reload_current_scene()
                $Restart.modulate.a = (dead-5)/4.0
                
            return
        alive += delta
        var orb = players[0].orb_value
        if orb > 1:
            material.set_shader_param("tint_mix", min((orb-1)/10.0,1))
        else:
            material.set_shader_param("tint_mix", 0)
            
func set_text():
    var mils = fmod(alive,1)*100
    var secs = fmod(alive,60)
    var mins = fmod(alive, 60*60) / 60

    var time_passed = "%d:%02d.%02d" % [mins,secs,mils]
    $you_dead_text/Endtime.text = "Time: " + time_passed




