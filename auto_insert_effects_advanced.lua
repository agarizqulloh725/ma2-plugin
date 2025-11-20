-- *********************************************
-- Auto Insert Effects Plugin - ADVANCED VERSION
-- Automatically inserts sample dimmer effects with more options
-- *********************************************

local internal_name = select(1,...);
local visible_name = select(2,...);

gma.echo("===========================================");
gma.echo("Auto Insert Effects Plugin (Advanced) Loaded");
gma.echo("===========================================");

-- *********************************************
-- ADVANCED Configuration: More effects with different settings
-- *********************************************

local effects_config = {
    -- Basic Dimmer Effects
    {
        number = 1,
        name = "Dim Sine Slow",
        preset_type = "Dimmer",
        form = "Sine",
        bpm = 40,
        width = 100,
        phase = 0,
        description = "Slow smooth sine wave"
    },
    {
        number = 2,
        name = "Dim Sine Fast",
        preset_type = "Dimmer",
        form = "Sine",
        bpm = 120,
        width = 100,
        phase = 0,
        description = "Fast smooth sine wave"
    },
    {
        number = 3,
        name = "Dim Ramp Up",
        preset_type = "Dimmer",
        form = "Ramp",
        bpm = 60,
        width = 100,
        phase = 0,
        description = "Linear ramp up"
    },
    {
        number = 4,
        name = "Dim Saw",
        preset_type = "Dimmer",
        form = "Saw",
        bpm = 80,
        width = 100,
        phase = 0,
        description = "Sawtooth wave"
    },
    {
        number = 5,
        name = "Dim Random",
        preset_type = "Dimmer",
        form = "Random",
        bpm = 100,
        width = 100,
        phase = 0,
        description = "Random dimmer changes"
    },
    {
        number = 6,
        name = "Dim Square",
        preset_type = "Dimmer",
        form = "Square",
        bpm = 90,
        width = 50,
        phase = 0,
        description = "Square wave 50% duty"
    },
    {
        number = 7,
        name = "Dim Pulse",
        preset_type = "Dimmer",
        form = "Pulse",
        bpm = 120,
        width = 20,
        phase = 0,
        description = "Short pulses"
    },
    {
        number = 8,
        name = "Dim Step 4",
        preset_type = "Dimmer",
        form = "Step",
        bpm = 60,
        width = 100,
        blocks = 4,
        description = "4-step dimmer"
    },
    -- Color Effects (if fixtures support RGB)
    {
        number = 9,
        name = "RGB Rainbow",
        preset_type = "Color",
        form = "Sine",
        bpm = 30,
        width = 100,
        phase = 120,
        description = "Rainbow color effect"
    },
    {
        number = 10,
        name = "RGB Strobe",
        preset_type = "Color",
        form = "Square",
        bpm = 180,
        width = 50,
        phase = 0,
        description = "Color strobe effect"
    }
};

-- *********************************************
-- Function to check if fixtures exist
-- *********************************************

local function check_fixtures()
    local fixture_handle = gma.show.getobj.handle("Fixture 1");
    if not fixture_handle then
        gma.gui.msgbox("Warning", "No fixtures found in show. Please patch fixtures first.");
        return false;
    end
    return true;
end

-- *********************************************
-- Function to create a single effect with advanced options
-- *********************************************

local function create_effect(config, progress_handle)
    gma.echo("Creating Effect " .. config.number .. ": " .. config.name);
    
    if progress_handle then
        gma.gui.progress.settext(progress_handle, "Creating " .. config.name .. "...");
    end
    
    -- Clear and select fixtures
    gma.cmd("ClearAll");
    gma.cmd("Fixture Thru");
    
    -- Set preset type and select attribute (this creates the selection needed for At Form)
    gma.cmd("Presettype \"" .. config.preset_type .. "\"");
    
    -- Now set form and BPM (attribute is now selected)
    gma.cmd("At Form \"" .. config.form .. "\"");
    gma.cmd("At EffectBPM " .. config.bpm);
    
    -- Store the effect
    gma.cmd("Store Effect " .. config.number .. " /nc");
    gma.sleep(0.5);
    
    -- Apply advanced settings using Assign command
    local assign_cmd = "Assign Effect " .. config.number;
    
    if config.width then
        assign_cmd = assign_cmd .. " /width=" .. config.width;
    end
    
    if config.phase then
        assign_cmd = assign_cmd .. " /phase=" .. config.phase;
    end
    
    if config.blocks then
        assign_cmd = assign_cmd .. " /blocks=" .. config.blocks;
    end
    
    -- Execute assign command if there are additional parameters
    if config.width or config.phase or config.blocks then
        gma.cmd(assign_cmd);
        gma.sleep(0.3);
    end
    
    -- Label the effect
    gma.cmd("Label Effect " .. config.number .. " \"" .. config.name .. "\"");
    gma.sleep(0.3);
    
    gma.echo("  ✓ Effect " .. config.number .. " created successfully");
    
    return true;
end

-- *********************************************
-- Main function to insert all effects
-- *********************************************

local function insert_all_effects()
    gma.echo("");
    gma.echo("Starting automatic effect insertion (Advanced)...");
    gma.echo("");
    
    if not check_fixtures() then
        return false;
    end
    
    local confirm = gma.gui.confirm(
        "Auto Insert Effects (Advanced)",
        "This will create " .. #effects_config .. " sample effects (Effect 1-" .. #effects_config .. ").\n\n" ..
        "Including:\n" ..
        "- 8 Dimmer effects (various forms)\n" ..
        "- 2 Color effects (if fixtures support RGB)\n\n" ..
        "Any existing effects will be overwritten.\n\n" ..
        "Continue?"
    );
    
    if not confirm then
        gma.echo("Effect insertion cancelled by user.");
        return false;
    end
    
    local progress = gma.gui.progress.start("Auto Insert Effects (Advanced)");
    gma.gui.progress.setrange(progress, 0, #effects_config);
    
    local success_count = 0;
    for i, config in ipairs(effects_config) do
        gma.gui.progress.set(progress, i - 1);
        
        local success = create_effect(config, progress);
        if success then
            success_count = success_count + 1;
        end
    end
    
    gma.gui.progress.set(progress, #effects_config);
    gma.sleep(0.5);
    gma.gui.progress.stop(progress);
    
    gma.cmd("ClearAll");
    
    gma.echo("");
    gma.echo("===========================================");
    gma.echo("Effect insertion completed!");
    gma.echo("Successfully created: " .. success_count .. " / " .. #effects_config .. " effects");
    gma.echo("===========================================");
    gma.echo("");
    
    local summary = "Successfully created " .. success_count .. " effects:\n\n";
    summary = summary .. "DIMMER EFFECTS:\n";
    for i = 1, 8 do
        local config = effects_config[i];
        summary = summary .. "Effect " .. config.number .. ": " .. config.name .. "\n";
    end
    summary = summary .. "\nCOLOR EFFECTS:\n";
    for i = 9, 10 do
        local config = effects_config[i];
        summary = summary .. "Effect " .. config.number .. ": " .. config.name .. "\n";
    end
    summary = summary .. "\nCheck your Effect Pool!";
    
    gma.gui.msgbox("Auto Insert Effects - Complete", summary);
    
    return true;
end

-- *********************************************
-- Plugin entry point
-- *********************************************

function Start()
    gma.echo("Starting Auto Insert Effects plugin (Advanced)...");
    gma.sleep(0.2);
    insert_all_effects();
end

-- *********************************************
-- Cleanup function
-- *********************************************

function Cleanup()
    gma.echo("Auto Insert Effects plugin (Advanced) cleanup called");
end

-- *********************************************
-- Return entry and cleanup functions
-- *********************************************

return Start, Cleanup;
