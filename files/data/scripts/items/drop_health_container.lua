dofile_once("data/scripts/lib/utilities.lua")
dofile( "mods/health_container/config.lua" )

function do_money_drop( amount_multiplier )	
	local entity = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity )
	local rand = math.random( 0, DropChance )
	
	if ( GameGetIsTrailerModeEnabled() ) then return end

	if( rand == 0 ) then 
		EntityLoad( "mods/health_container/files/data/entities/items/pickup/health_container.xml", x, y-8 )
	end
end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	do_money_drop( 1 )
end