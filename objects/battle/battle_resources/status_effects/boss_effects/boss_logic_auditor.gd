@tool
extends StatusEffect
class_name AuditorLogic

const ACTION_BULL_MARKET := preload("res://objects/battle/battle_resources/misc_movies/auditor/bull_market.tres")
var logic_effect : StatusEffect

var auditor: Cog:
	get: return target
var gag_tracks: Array[Track]:
	get: return Util.get_player().stats.character.gag_loadout.loadout

var bull_market := false
var cogs := {}

# Called by battle manager on initial application
func apply() -> void:
	rounds = -1
	manager.s_round_started.connect(round_started)
	super()
	manager.s_participant_will_die.connect(check_if_cog_destroyed)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)
	if manager.s_actions_ended.is_connected(round_ended):
		manager.s_actions_ended.disconnect(round_ended)
	print("test 2")
	AudioManager.set_music(load('res://audio/music/supervisors/ttr_s_ara_chq_facilityBossNoMarket.ogg'))
	
	if manager.s_participant_will_die.is_connected(check_if_cog_destroyed):
		manager.s_participant_will_die.disconnect(check_if_cog_destroyed)
		
func check_if_cog_destroyed(who):
	#if who == auditor:
	#	AudioManager.set_music(load('res://audio/music/supervisors/ttr_s_ara_chq_facilityBossNoMarket.ogg'))
	if who is Cog && not bull_market:
		apply_bull_market()

func round_started(_actions: Array[BattleAction]) -> void:
	for cog in manager.cogs:
		cogs[cog] = cog.stats.hp
	var surviving_cogs : Array[Cog] = []
	for cog in manager.cogs:
		check_if_cog_destroyed(cog)
	print(surviving_cogs)
	if surviving_cogs.size() < 4 && not bull_market:
		print("trying to swap")
		#apply_bull_market()
		
func round_ended() -> void:
	print("weh")
		
	var surviving_cogs : Array[Cog] = []
	for cog in manager.cogs:
		if cog.stats.hp > 0:
			surviving_cogs.append(cog)
	print(surviving_cogs)
	if surviving_cogs.size() < 4 && not bull_market:
		print("trying to swap...2!")
		#apply_bull_market()

func apply_bull_market() -> void:
	var action := ACTION_BULL_MARKET.duplicate()
	action.user = target
	action.targets = [Util.get_player()]
	manager.round_end_actions.append(action)
	print("bull market start")
	bull_market = true
