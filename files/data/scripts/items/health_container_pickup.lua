dofile_once( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "mods/health_container/config.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	local pos_x, pos_y = EntityGetTransform( entity_item )
	
	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
	
	if( damagemodels ~= nil ) then
		for i,v in ipairs(damagemodels) do
			currenthp = tonumber( ComponentGetValue( v, "hp" ) )
			current_max_hp = tonumber( ComponentGetValue( v, "max_hp") )
			
			local targethp = currenthp + (HealAmount * 0.04) -- Health values are scaled up by 25 in the UI apparently. So using this multiplier will allow the correct hp to be set
			local target_max_hp = current_max_hp + (MaxHealthIncrease * 0.04)
			
			ComponentSetValue( v, "max_hp", target_max_hp)
			if( targethp > target_max_hp ) then targethp = target_max_hp end
			ComponentSetValue( v, "hp", targethp)
			break
		end
	end

	GamePlaySound("mods/health_container/files/health_container_audio.snd", "health_container/hc_heal", pos_x, pos_y)
	shoot_projectile( entity_item, "mods/health_container/files/data/entities/particles/health_container_pickup.xml", pos_x, pos_y, 0, 0 )
	EntityKill( entity_item )
end
