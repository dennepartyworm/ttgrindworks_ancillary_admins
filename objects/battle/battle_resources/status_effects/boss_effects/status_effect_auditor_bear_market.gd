@tool
extends StatusEffect
class_name AuditorBearMarket

const mod_effect := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_auditor_bear_market.tres")
const BOOST_AMOUNT := 1.50
const STAT_BOOST_RESOURCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
var boost_effects: Array[StatBoost] = []

func apply() -> void:
	manager.battle_stats[Util.get_player()].gag_price_mult *= 2
	
	var toon_buff := STAT_BOOST_RESOURCE.duplicate()
	toon_buff.target = Util.get_player()
	toon_buff.rounds = -1
	toon_buff.quality = StatusEffect.EffectQuality.POSITIVE
	toon_buff.stat = 'defense'
	toon_buff.boost = BOOST_AMOUNT
	manager.add_status_effect(toon_buff)
	boost_effects.append(toon_buff)
	#manager.battle_text(Util.get_player(), "Defense Up!", BattleText.colors.orange[0], BattleText.colors.orange[1])
	
	#mod_effect.target = target
	#manager.add_status_effect(mod_effect)

func cleanup() -> void:
	manager.battle_stats[Util.get_player()].gag_price_mult /= 2
	for effect in boost_effects:
		if effect.target in manager.battle_stats.keys():
			print("bye status effect")
			manager.expire_status_effect(effect)
