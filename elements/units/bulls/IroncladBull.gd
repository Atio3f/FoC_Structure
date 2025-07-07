extends AbstractUnit
class_name IroncladBull

const idUnit = "test:IroncladBull"
const POTENTIAL = 3#Maybe 4?
const img = ""
func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, 48, 21, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 3, 8, 0, POTENTIAL, 1)
	var effect1: AbstractEffect = IroncladBullEffect.new(self)
	effects.append(effect1)
	tags.append(Tags.tags.BULL)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
