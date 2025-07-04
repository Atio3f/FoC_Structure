extends Node
class_name AbstractEffect
var id: String
var nameEffect: String
var imgEffect: Sprite2D
var imgPath: String
var unitAssociated: AbstractUnit
var unitsStocked: Array[AbstractUnit] = []	#Can be used if the effect need to stock units affected or the source?
var remainingTurns: int = -1	#Indicate how many turn before the end of the effect. If the effect is permanent, this value is -1
var priority: int	#Serve to place the effect on the Array on the unit. Determine if the order when we iterate effects
var stackable: bool	#Allow to know if we can stack effects
#3 values to assign values to the effect once  
var value_A: int
var value_B: int
var value_C: int 
var counter: int #Can be used to increment a value 
func _init(id: String, imgPath: String, unit: AbstractUnit, remainingTurns: int, priority: int, stackable: bool, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	self.id = id
	self.imgPath = imgPath
	#INSERER IMAGE A PARTIR DU PATH ICI
	self.unitAssociated = unit
	self.remainingTurns = remainingTurns
	self.priority = priority
	self.stackable = stackable
	self.value_A = value_A
	self.value_B = value_B
	self.value_C = value_C
	self.counter = counter

func mergeEffect(effectToMerge: AbstractEffect) -> void:
	value_A += effectToMerge.value_A
	value_B += effectToMerge.value_B
	value_C += effectToMerge.value_C
	counter += effectToMerge.counter
	
	if remainingTurns != -1 and effectToMerge.remainingTurns != -1:
		remainingTurns = remainingTurns + effectToMerge.remainingTurns

	onEffectApplied(false, effectToMerge)

func onPlacement(tile: String) -> void:
	1

#First time is to use when we have stackable effects which can modify values
#Parameter oldEffect serve to calculate how much we need to add in some effects like powerplus
func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null) -> void:
	1

func onEffectEnd() -> void:
	1

#Will probably replace onUnitPlace for final version 
func onCardPlay(player: AbstractPlayer) -> void:
	1

func onUnitPlace(unit: AbstractUnit) -> void:
	1

func onMovement() -> void:
	1

func onItemUsed(item: AbstractItem, player: AbstractPlayer) -> void:
	1

#Return final damage taken, visualisation serves to avoid activating effects like damage on offender before a true attack 
func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	return damage

#Return final damage taken
func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes) -> int :
	return damage

func onHeal(unitHealed: AbstractUnit, healValue: int) -> int :
	return healValue

func onHealed(unitHealing: AbstractUnit, healValue: int) -> int :
	return healValue

func onKill(unitKilled: AbstractUnit) -> void :
	1
func onDeath(unit: AbstractUnit) -> void:
	1

func onLevelUp(level: int) -> void :
	1

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	1

func registerEffect() -> Dictionary:
	return {
		"id": id,
		"nameEffect": nameEffect,
		"className": get_class(),
		"unitAssociatedId": unitAssociated.id,
		"unitsStockedIds": unitsStocked.map(func(u): return u),
		"remainingTurns": remainingTurns,
		"priority": priority,
		"stackable": stackable,
		"value_A": value_A,
		"value_B": value_B,
		"value_C": value_C,
		"counter": counter
	}

static func recoverEffect(effectJson: JSON, unit: AbstractUnit) -> AbstractEffect :
	var data : Dictionary = effectJson.data
	#Create a effect with all elements associated
	if EffectDb.EFFECTS.has(data.className):
		var effect = EffectDb.EFFECTS[data.className].new(data.id, data.imgPath, unit, data.remainingTurns, data.priority, data.stackable, data.value_A, data.value_B, data.value_C, data.counter)
		return effect
	else :
		push_error("EFFECT CLASS NOT FIND " + data.className)
		return null#Maybe create a unit via ?
	

