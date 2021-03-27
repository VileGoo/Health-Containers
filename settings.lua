dofile("data/scripts/lib/mod_settings.lua")

-- Use ModSettingGet() in the game to query settings.
local mod_id = "health_container"
mod_settings_version = 1
mod_settings = 
{
  {
    category_id = "health_container_settings",
    ui_name = "Health Container Settings",
    ui_description = "Settings for the health container drops.",
    settings = 
    {
      {
        id = "drop_chance",
        ui_name = "Drop Chance",
        ui_description = "Chance that a health container drops upon killing an enemy.",
        value_default = 0.1,
        value_min = 0,
        value_max = 1,
        value_display_multiplier = 100,
        value_display_formatting = " $0 %",
        scope = MOD_SETTING_SCOPE_RUNTIME,
      },	  
      {
        id = "max_health_increase",
        ui_name = "Max Health Increase",
        ui_description = "Amount to increase the max player health by. Takes effect on new game.",
        value_default = 0,
        value_min = 0,
        value_max = 4,
        value_display_multiplier = 25,
        value_display_formatting = " $0 HP",
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "heal_mode",
        ui_name = "Health Container Healing Mode",
        ui_description = "Set whether health containers heal a fixed amount or a percent of max health.",
        value_default = "fixed",
        values = { {"percent", "Percent"}, {"fixed", "Fixed"} },
        scope = MOD_SETTING_SCOPE_RUNTIME,
      },
      {
        id = "heal_amount",
        ui_name = "Healing Amount (Fixed)",
        ui_description = "Fixed amount of HP to heal each pickup.",
        value_default = 0.4,
        value_min = 0,
        value_max = 4,
        value_display_multiplier = 25,
        value_display_formatting = " $0 HP",
        scope = MOD_SETTING_SCOPE_RUNTIME,
      },
      {
        id = "heal_percent",
        ui_name = "Healing Amount (Percentage)",
        ui_description = "Percentage of Max HP to heal on each pickup.",
        value_default = 0.10,
        value_min = 0,
        value_max = 1,
        value_display_multiplier = 100,
        value_display_formatting = " $0 %",
        scope = MOD_SETTING_SCOPE_RUNTIME,
      }
    }
  }
}

-- This function is called to ensure the correct setting values are visible to the game via ModSettingGet(). your mod's settings don't work if you don't have a function like this defined in settings.lua.
-- This function is called:
--		- when entering the mod settings menu (init_scope will be MOD_SETTINGS_SCOPE_ONLY_SET_DEFAULT)
-- 		- before mod initialization when starting a new game (init_scope will be MOD_SETTING_SCOPE_NEW_GAME)
--		- when entering the game after a restart (init_scope will be MOD_SETTING_SCOPE_RESTART)
--		- at the end of an update when mod settings have been changed via ModSettingsSetNextValue() and the game is unpaused (init_scope will be MOD_SETTINGS_SCOPE_RUNTIME)
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

-- This function should return the number of visible setting UI elements.
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic.
-- The value will be used to determine whether or not to display various UI elements that link to mod settings.
-- At the moment it is fine to simply return 0 or 1 in a custom implementation, but we don't guarantee that will be the case in the future.
-- This function is called every frame when in the settings menu.
function ModSettingsGuiCount()
	-- if (not DebugGetIsDevBuild()) then --if these lines are enabled, the menu only works in noita_dev.exe.
	-- 	return 0
	-- end

	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
  mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end