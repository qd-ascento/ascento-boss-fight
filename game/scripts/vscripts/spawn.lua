
SAVE_HEALTH = false

if Spawn == nil then
	_G.Spawn = class({})
end

function Spawn:InitGameMode()
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(Spawn, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(Spawn, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(Spawn, 'OnPlayerLevelUp'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(Spawn, 'OnEntityHurt'), self)

end

function Spawn:OnPlayerLevelUp( keys )
	local player = EntIndexToHScript(keys.player)
    local hero = player:GetAssignedHero()
    local level = keys.level
	
	if level > 30 then
		hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)-- !
	elseif level >= 19 and level < 25 then
		hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)-- !
	elseif level == 26 then
		hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)-- !
	end
	
end
	
function Spawn:OnGameRulesStateChange( keys )
	local newState = GameRules:State_Get()
	--print("event OnGameRulesStateChange has called")

	if newState == DOTA_GAMERULES_STATE_PRE_GAME then
		Spawn:FirstSpawnBoss()
		--Spawn:SpawnBonusBox()
	end
end

function Spawn:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerUnit = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	local team = DOTA_TEAM_NEUTRALS
	--print("event OnEntityKilled has called")


	if name == "npc_boss1" then


		local caster_respoint = Entities:FindByName(nil,"spawner_boss_1"):GetAbsOrigin() --Пробиваем адрес дома
		Timers:CreateTimer(30, function()              --Через сколько секунд появится новый фраер(5)
  		    local unit = CreateUnitByName(name, caster_respoint + RandomVector( RandomFloat( 0, 50)), true, nil, nil, team) --создаем нового пацыка по трем аргументам ( имя покойного ,адрес дома ,true,nil,nil,команда терпилы)

  	    end)

	end
end

function Spawn:FirstSpawnBoss( keys )

	local name = "npc_boss1" 
	local spawnPosition1 = Entities:FindByName(nil, "spawner_boss_1"):GetAbsOrigin()

	local unit = CreateUnitByName(name, spawnPosition1 + RandomVector( RandomFloat( 0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)

end

				--GameRules:SendCustomMessage("#Game_notification_",0,0)
function Spawn:DropItem( unit, item_name, chance )
	local ranFloat = RandomFloat(0, 100)
	if ranFloat <= chance then		
		local spawnPoint = unit:GetAbsOrigin()	
		local newItem = CreateItem( item_name, nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local initialPoint = unit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 125 ) )

		newItem:LaunchLootInitialHeight( false, 0, 150, 0.75, initialPoint )
	end
end

function GiveGoldPlayers( gold )
	for index=0 ,4 do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			hero:ModifyGold(gold, false, 0)
			SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, hero, gold, nil )
		end
	end
end

function CDOTA_BaseNPC:GiveExperiencePlayers( experience )
	local team = self:GetTeam()
	for index=0 ,9 do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			local hero_team = hero:GetTeam()
			if hero_team == team then
				hero:AddExperience(experience, 0, false, true )
			end
		end
	end
end


function Spawn:OnEntityHurt( event )
  local attacker = EntIndexToHScript(event.entindex_attacker)
  local target = EntIndexToHScript(event.entindex_killed)
  local damage = event.damage
  local damage_handle = EntIndexToHScript(event.damagebits )
  -- print(damage_handle.damage_type)
  -- for key, value in pairs(damage_handle) do
  --   print(key, value)
  -- end

end

Spawn:InitGameMode()