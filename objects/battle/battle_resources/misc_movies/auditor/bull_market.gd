extends CogAttack

const EFFECT_BULL_MARKET := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_auditor_bull_market.tres')

var logic_effect : StatusEffect


func action() -> void:
	var cog : Cog = user
	var player : Player = targets[0]
	
	# Movie Start
	var movie := manager.create_tween()
	
	# Focus Cog
	movie.tween_callback(cog.face_position.bind(player.global_position))
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('cross'))
	movie.tween_callback(apply_effect)
	movie.tween_interval(4.5)
	AudioManager.set_music(load('res://audio/music/supervisors/ttr_s_ara_chq_facilityBossBull.ogg'))
	
	await movie.finished
	movie.kill()

func apply_effect() -> void:
	var new_effect := EFFECT_BULL_MARKET.duplicate()
	new_effect.target = targets[0]
#	new_effect.logic_effect = logic_effect
	manager.add_status_effect(new_effect)
