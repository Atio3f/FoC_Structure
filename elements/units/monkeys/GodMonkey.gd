extends AbstractUnit
class_name GodMonkey

const idUnit = "test:GodMonkey"
const POTENTIAL = 4
const img = ""
func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, 45, 23, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 22, 6, 6, POTENTIAL, 24)
	var effect1: AbstractEffect = GodMonkeySpeedEffect.new(self)
	var effect2: AbstractEffect = GodMonkeyHealEffect.new(self)
	effects.append(effect1)
	tags.append(Tags.tags.MONKEY)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
