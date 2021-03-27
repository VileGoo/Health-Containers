dofile_once("data/scripts/game_helpers.lua")
dofile_once("data/scripts/lib/utilities.lua")

function item_pickup( entity_item, entity_who_picked, item_name )
	
	local function TruncateHpValue( value )
		-- this function reduces inaccuracy building up over time due to how HP is handled and 
		-- how this version of lua seems to handle floating point values.
		-- This function truncates values less than 1 HP (<0.04)
		local shifted = value * 100
		local truncated = shifted - (shifted % 4)
		return truncated / 100
	end

	local pos_x, pos_y = EntityGetTransform( entity_item )
	
	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
	
	if( damagemodels ~= nil ) then
		for i,v in ipairs(damagemodels) do
			local current_hp = tonumber( ComponentGetValue( v, "hp" ) )
      
		local current_max_hp = tonumber( ComponentGetValue( v, "max_hp") )
		local heal_amt = 0
		local mode = ModSettingGet("health_container.heal_mode")
      
		if( tostring(mode) == "percent" ) then
			heal_amt = current_max_hp * ( ModSettingGet("health_container.heal_percent"))
		else
			heal_amt = ModSettingGet("health_container.heal_amount") -- Health values are scaled up by 25 in the UI apparently.
		end
		
		heal_amt = math.max(heal_amt, 0.04) -- set heal_amt to be at least 1 HP
		local target_hp = TruncateHpValue(current_hp + heal_amt)
      
		-- handle expansion of max HP:
		local max_incr_amt = ModSettingGet("health_container.max_health_increase")
		
		if (max_incr_amt > 0) then
			max_incr_amt = math.max(0.04, max_incr_amt) -- set increase amt to at least 1 HP
		end

		local target_max_hp = TruncateHpValue(current_max_hp + max_incr_amt)

		-- Save values
		ComponentSetValue( v, "max_hp", target_max_hp)
		
		if( target_hp > target_max_hp ) then target_hp = target_max_hp end
			ComponentSetValue( v, "hp", target_hp)
			GamePrint("Picked up Health (" .. (TruncateHpValue(heal_amt) * 25) .. ")")
			break
		end
	end

	GamePlaySound("mods/health_container/files/health_container_audio.snd", "health_container/hc_heal", pos_x, pos_y)
	shoot_projectile( entity_item, "mods/health_container/files/data/entities/particles/health_container_pickup.xml", pos_x, pos_y, 0, 0 )
	EntityKill( entity_item )
end



