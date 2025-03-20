@tool
extends StatusEffect

const BOOST_AMOUNT := 1.50
const STAT_BOOST_RESOURCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
var auditor: Cog
var boost_effects: Array[StatBoost] = []

func apply() -> void:
	print("did we get this far...")
	manager.s_participant_joined.connect(participant_joined)
	print(manager.status_effects)
	#var user: Cog = target
	for cog in manager.cogs:
		apply_to_cog(cog)
		print("test apply to cog")
	apply_to_toon(Util.get_player())
	
	if auditor:
		manager.s_participant_died.connect(check_participant_died)

func check_participant_died(participant: Node3D) -> void:
	if auditor and auditor == participant:
		manager.expire_status_effect(self)


func cleanup() -> void:
	if manager.s_participant_joined.is_connected(participant_joined):
		manager.s_participant_joined.disconnect(participant_joined)
	end_boost()
	

func participant_joined(who: Node3D) -> void:
	if who is Cog:
		apply_to_cog(who)

func apply_to_cog(cog: Cog) -> void:
	var new_boost := create_boost(cog)
	manager.add_status_effect(new_boost)
	boost_effects.append(new_boost)
	
func apply_to_toon(player: Player) -> void:
	print("test apply to toon")
	var toon_buff := STAT_BOOST_RESOURCE.duplicate()
	toon_buff.target = player
	toon_buff.rounds = -1
	toon_buff.quality = StatusEffect.EffectQuality.POSITIVE
	toon_buff.stat = 'damage'
	toon_buff.boost = BOOST_AMOUNT
	manager.add_status_effect(toon_buff)
	boost_effects.append(toon_buff)
	manager.battle_text(player, "Damage Up!", BattleText.colors.orange[0], BattleText.colors.orange[1])

func create_boost(who: Cog) -> StatBoost:
	var status_effect := STAT_BOOST_RESOURCE.duplicate()
	status_effect.target = who
	status_effect.boost = BOOST_AMOUNT
	status_effect.description = "+50% Attack"
	status_effect.stat = 'damage'
	status_effect.rounds = -1
	status_effect.quality = StatusEffect.EffectQuality.POSITIVE
	# Allowing these to combine can cause problems when the owner cog dies
	status_effect.force_no_combine = true
	return status_effect

func end_boost() -> void:
	for effect in boost_effects:
		if effect.target in manager.battle_stats.keys():
			print("bye status effect")
			manager.expire_status_effect(effect)
