-- *********************************************
-- Auto Insert Effects Plugin v4.0
-- Creates macros only, effects created on macro click
-- *********************************************

local internal_name = select(1,...);
local visible_name = select(2,...);

gma.echo("===========================================");
gma.echo("Auto Insert Effects Plugin v4.0 Loaded");
gma.echo("Smart Macros - Effects created on-demand");
gma.echo("===========================================");

-- *********************************************
-- Configuration: All 23 available effect forms
-- *********************************************

local effects_config = {
    -- Row 1 (kiri ke kanan)
    {number = 1, name = "Stomp", form = 1, bpm = 60},
    {number = 2, name = "Release", form = 2, bpm = 60},
    {number = 3, name = "Random", form = 3, bpm = 150},
    {number = 4, name = "Pwm", form = 4, bpm = 50},
    {number = 5, name = "Chase", form = 5, bpm = 100},
    {number = 6, name = "Flat Low", form = 6, bpm = 60},
    
    -- Row 2 (kiri ke kanan)
    {number = 7, name = "Flat High", form = 7, bpm = 60},
    {number = 8, name = "Sin", form = 8, bpm = 60},
    {number = 9, name = "Cos", form = 9, bpm = 60},
    {number = 10, name = "Ramp Plus", form = 10, bpm = 70},
    {number = 11, name = "Ramp Minus", form = 11, bpm = 70},
    {number = 12, name = "Ramp", form = 12, bpm = 70},
    
    -- Row 3 (kiri ke kanan)
    {number = 13, name = "Phase 1", form = 13, bpm = 60},
    {number = 14, name = "Phase 2", form = 14, bpm = 60},
    {number = 15, name = "Phase 3", form = 15, bpm = 60},
    {number = 16, name = "Bump", form = 16, bpm = 80},
    {number = 17, name = "Swing", form = 17, bpm = 50},
    {number = 18, name = "Ramp 50", form = 18, bpm = 70},
    
    -- Row 4 (kiri ke kanan)
    -- {number = 19, name = "Circle", form = 19, bpm = 40},
    -- {number = 20, name = "Sound", form = 20, bpm = 120},
    -- {number = 21, name = "Flyout", form = 21, bpm = 60},
    -- {number = 22, name = "Wave", form = 22, bpm = 50},
    -- {number = 23, name = "Cross", form = 23, bpm = 60}
};

-- *********************************************
-- Function to create smart macro
-- Uses exact command sequence from reference
-- *********************************************

local function create_smart_macro(macro_number, config)
    gma.echo("Creating smart macro " .. macro_number .. ": " .. config.name);
    
    -- Store the macro
    gma.cmd("Store Macro 1." .. macro_number .. " /nc");
    
    -- Line 1: Select Dimmer preset type
    gma.cmd("Store Macro 1." .. macro_number .. ".1 /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. ".1 /cmd=\"Presettype Dimmer\"");
    
    -- Line 2: Set form (using form number)
    gma.cmd("Store Macro 1." .. macro_number .. ".2 /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. ".2 /cmd=\"At Form " .. config.form .. "\"");
    
    -- Line 3: Set BPM
    gma.cmd("Store Macro 1." .. macro_number .. ".3 /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. ".3 /cmd=\"At EffectBPM " .. config.bpm .. "\"");
    
    -- Line 4: Store effect (auto finds empty slot)
    gma.cmd("Store Macro 1." .. macro_number .. ".4 /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. ".4 /cmd=\"Store Effect /nc\"");
    
    -- Line 5: Clear programmer
    gma.cmd("Store Macro 1." .. macro_number .. ".5 /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. ".5 /cmd=\"ClearAll\"");
    
    -- Label the macro
    gma.cmd("Label Macro " .. macro_number .. " \"" .. config.name .. "\"");
    
    gma.echo("  ✓ Smart macro " .. macro_number .. " created");
    
    return true;
end

-- *********************************************
-- Main function to create all macros
-- *********************************************

local function create_all_macros()
    gma.echo("");
    gma.echo("===========================================");
    gma.echo("Creating Smart Macros...");
    gma.echo("Total: " .. #effects_config .. " macros");
    gma.echo("===========================================");
    gma.echo("");
    
    local confirm = gma.gui.confirm(
        "Auto Insert Effects - Smart Macros",
        "This will create " .. #effects_config .. " smart macros.\n\n" ..
        "HOW IT WORKS:\n" ..
        "1. Macros created immediately (NO effects yet)\n" ..
        "2. When you CLICK a macro:\n" ..
        "   - Effect is auto-created in Effect Pool\n" ..
        "3. Each click creates NEW effect\n\n" ..
        "All 23 effect forms:\n" ..
        "Stomp, Release, Random, Pwm, Chase, Flat Low/High,\n" ..
        "Sin, Cos, Ramp Plus/Minus/50, Ramp, Phase 1/2/3,\n" ..
        "Bump, Swing, Circle, Sound, Flyout, Wave, Cross\n\n" ..
        "Continue?"
    );
    
    if not confirm then
        gma.echo("Macro creation cancelled by user.");
        return false;
    end
    
    local progress = gma.gui.progress.start("Creating Smart Macros");
    gma.gui.progress.setrange(progress, 0, #effects_config);
    
    local success_count = 0;
    local failed_macros = {};
    
    for i, config in ipairs(effects_config) do
        gma.gui.progress.set(progress, i - 1);
        gma.gui.progress.settext(progress, "Creating macro: " .. config.name);
        
        local success, err = pcall(function()
            return create_smart_macro(i, config);
        end);
        
        if success and err then
            success_count = success_count + 1;
        else
            table.insert(failed_macros, config.name);
            gma.echo("  ✗ Failed to create macro: " .. config.name);
        end
    end
    
    gma.gui.progress.set(progress, #effects_config);
    gma.gui.progress.stop(progress);
    
    gma.cmd("ClearAll");
    
    gma.echo("");
    gma.echo("===========================================");
    gma.echo("Smart Macro creation completed!");
    gma.echo("Successfully created: " .. success_count .. " / " .. #effects_config .. " macros");
    if #failed_macros > 0 then
        gma.echo("Failed macros: " .. table.concat(failed_macros, ", "));
    end
    gma.echo("===========================================");
    gma.echo("");
    
    local summary = "✅ SMART MACROS CREATED: " .. success_count .. " / " .. #effects_config .. "\n\n";
    summary = summary .. "HOW TO USE:\n";
    summary = summary .. "1. Go to Macro Pool\n";
    summary = summary .. "2. Click any macro button (1-23)\n";
    summary = summary .. "3. Effect will be auto-created in Effect Pool\n\n";
    summary = summary .. "Each macro command sequence:\n";
    summary = summary .. "Presettype Dimmer → At Form [number] →\n";
    summary = summary .. "At EffectBPM [bpm] → Store Effect → ClearAll\n\n";
    summary = summary .. "Effects created on-demand!";
    
    if #failed_macros > 0 then
        summary = summary .. "\n\n⚠️ Some macros failed:\n";
        summary = summary .. table.concat(failed_macros, ", ");
    end
    
    gma.gui.msgbox("Smart Macros - Complete", summary);
    
    return true;
end

-- *********************************************
-- Plugin entry point
-- *********************************************

function Start()
    gma.echo("Starting Auto Insert Effects plugin...");
    create_all_macros();
end

-- *********************************************
-- Cleanup function
-- *********************************************

function Cleanup()
    gma.echo("Auto Insert Effects plugin cleanup called");
end

-- *********************************************
-- Return entry and cleanup functions
-- *********************************************

return Start, Cleanup;
