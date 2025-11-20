-- *********************************************
-- Auto Insert Effects Plugin for GrandMA2
-- Automatically inserts sample dimmer effects into the effect pool
-- *********************************************

local internal_name = select(1,...);
local visible_name = select(2,...);

gma.echo("===========================================");
gma.echo("Auto Insert Effects Plugin Loaded");
gma.echo("Plugin: " .. internal_name);
gma.echo("===========================================");

-- *********************************************
-- Configuration: Define effects to create
-- *********************************************

local effects_config = {
    {
        number = 1,
        name = "Dimmer Sine",
        form = "Sine",
        bpm = 60,
        description = "Smooth sine wave dimmer effect"
    },
    {
        number = 2,
        name = "Dimmer Ramp",
        form = "Ramp",
        bpm = 80,
        description = "Linear ramp up dimmer effect"
    },
    {
        number = 3,
        name = "Dimmer Saw",
        form = "Saw",
        bpm = 100,
        description = "Sawtooth dimmer effect"
    },
    {
        number = 4,
        name = "Dimmer Random",
        form = "Random",
        bpm = 120,
        description = "Random dimmer effect"
    },
    {
        number = 5,
        name = "Dimmer Square",
        form = "Square",
        bpm = 90,
        description = "Square wave dimmer effect"
    }
};

-- *********************************************
-- Function to check if fixtures exist
-- *********************************************

local function check_fixtures()
    -- Try to get fixture 1
    local fixture_handle = gma.show.getobj.handle("Fixture 1");
    if not fixture_handle then
        gma.gui.msgbox("Warning", "No fixtures found in show. Please patch fixtures first before creating effects.");
        return false;
    end
    return true;
end

-- *********************************************
-- Function to create a single effect
-- *********************************************

local function create_effect(config, progress_handle)
    gma.echo("Creating Effect " .. config.number .. ": " .. config.name);
    
    -- Update progress
    if progress_handle then
        gma.gui.progress.settext(progress_handle, "Creating " .. config.name .. "...");
    end
    
    -- Select all fixtures for the effect
    gma.cmd("ClearAll");
    gma.cmd("Fixture Thru");
    
    -- Set preset type to Dimmer (this selects the attribute)
    gma.cmd("Presettype \"Dimmer\"");
    
    -- Now set the form and BPM (attribute is now selected)
    gma.cmd("At Form \"" .. config.form .. "\"");
    gma.cmd("At EffectBPM " .. config.bpm);
    
    -- Store the effect
    gma.cmd("Store Effect " .. config.number .. " /nc");
    
    -- Give system time to save
    gma.sleep(0.5);
    
    -- Label the effect
    gma.cmd("Label Effect " .. config.number .. " \"" .. config.name .. "\"");
    
    -- Additional sleep to ensure label is saved
    gma.sleep(0.3);
    
    gma.echo("  ✓ Effect " .. config.number .. " created successfully");
    
    return true;
end

-- *********************************************
-- Main function to insert all effects
-- *********************************************

local function insert_all_effects()
    gma.echo("");
    gma.echo("Starting automatic effect insertion...");
    gma.echo("");
    
    -- Check if fixtures exist
    if not check_fixtures() then
        return false;
    end
    
    -- Ask user confirmation
    local confirm = gma.gui.confirm(
        "Auto Insert Effects",
        "This will create " .. #effects_config .. " sample dimmer effects (Effect 1-" .. #effects_config .. ").\n\n" ..
        "Any existing effects with these numbers will be overwritten.\n\n" ..
        "Continue?"
    );
    
    if not confirm then
        gma.echo("Effect insertion cancelled by user.");
        return false;
    end
    
    -- Create progress bar
    local progress = gma.gui.progress.start("Auto Insert Effects");
    gma.gui.progress.setrange(progress, 0, #effects_config);
    
    -- Create each effect
    local success_count = 0;
    for i, config in ipairs(effects_config) do
        gma.gui.progress.set(progress, i - 1);
        
        local success = create_effect(config, progress);
        if success then
            success_count = success_count + 1;
        end
    end
    
    -- Final progress update
    gma.gui.progress.set(progress, #effects_config);
    gma.sleep(0.5);
    gma.gui.progress.stop(progress);
    
    -- Clear selection
    gma.cmd("ClearAll");
    
    -- Show completion message
    gma.echo("");
    gma.echo("===========================================");
    gma.echo("Effect insertion completed!");
    gma.echo("Successfully created: " .. success_count .. " / " .. #effects_config .. " effects");
    gma.echo("===========================================");
    gma.echo("");
    
    -- Show summary in message box
    local summary = "Successfully created " .. success_count .. " effects:\n\n";
    for i, config in ipairs(effects_config) do
        summary = summary .. "Effect " .. config.number .. ": " .. config.name .. 
                  " (" .. config.form .. " @ " .. config.bpm .. " BPM)\n";
    end
    summary = summary .. "\nCheck your Effect Pool to see the results!";
    
    gma.gui.msgbox("Auto Insert Effects - Complete", summary);
    
    return true;
end

-- *********************************************
-- Plugin entry point
-- *********************************************

function Start()
    gma.echo("Starting Auto Insert Effects plugin...");
    
    -- Small delay to ensure system is ready
    gma.sleep(0.2);
    
    -- Insert all effects
    insert_all_effects();
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
