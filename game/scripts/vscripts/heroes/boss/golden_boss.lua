golden_boss = class({})

function golden_boss:GetIntrinsicModifierName()
	return "modifier_golden_boss"
end

modifier_golden_boss = class({
	IsHidden = function(self) return true end,
	DeclareFunctions = function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}end,
})

function modifier_golden_boss:OnAttackLanded(data)

	local caster = self:GetCaster()
	local target = data.target
	local attacker = data.attacker
	local goldDamage = data.damage
	

	
	if target == caster and attacker:IsRealHero() and not attacker:IsIllusion() then

		attacker:ModifyGold(goldDamage, true, 0)

	end
end
