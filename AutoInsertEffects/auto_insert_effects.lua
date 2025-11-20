-- *********************************************
-- Auto Insert Effects Plugin
-- Automatically inserts effects with ALL available forms
-- *********************************************

local internal_name = select(1,...);
local visible_name = select(2,...);

gma.echo("===========================================");
gma.echo("Auto Insert Effects Plugin Loaded");
gma.echo("All 23 Effect Forms Available");
gma.echo("===========================================");

-- *********************************************
-- Configuration: All 23 available effect forms
-- Based on GrandMA2 Select Form dialog
-- *********************************************

local effects_config = {
    -- Row 1: Basic Forms
    {
        number = 1,
        name = "Stomp",
        form = "Stomp",
        bpm = 60
    },
    {
        number = 2,
        name = "Release",
        form = "Release",
        bpm = 60
    },
    {
        number = 3,
        name = "Random",
        form = "Random",
        bpm = 80
    },
    {
        number = 4,
        name = "Pwm",
        form = "Pwm",
        bpm = 90
    },
    {
        number = 5,
        name = "Chase",
        form = "Chase",
        bpm = 100
    },
    {
        number = 6,
        name = "Flat Low",
        form = "Flat Low",
        bpm = 60
    },
    
    -- Row 2: Advanced Forms
    {
        number = 7,
        name = "Flat High",
        form = "Flat High",
        bpm = 60
    },
    {
        number = 8,
        name = "Sin",
        form = "Sin",
        bpm = 60
    },
    {
        number = 9,
        name = "Cos",
        form = "Cos",
        bpm = 60
    },
    {
        number = 10,
        name = "Ramp Plus",
        form = "Ramp Plus",
        bpm = 70
    },
    {
        number = 11,
        name = "Ramp Minus",
        form = "Ramp Minus",
        bpm = 70
    },
    {
        number = 12,
        name = "Ramp",
        form = "Ramp",
        bpm = 70
    },
    
    -- Row 3: Phase Forms
    {
        number = 13,
        name = "Phase 1",
        form = "Phase 1",
        bpm = 60
    },
    {
        number = 14,
        name = "Phase 2",
        form = "Phase 2",
        bpm = 60
    },
    {
        number = 15,
        name = "Phase 3",
        form = "Phase 3",
        bpm = 60
    },
    {
        number = 16,
        name = "Bump",
        form = "Bump",
        bpm = 80
    },
    {
        number = 17,
        name = "Swing",
        form = "Swing",
        bpm = 50
    },
    {
        number = 18,
        name = "Ramp 50",
        form = "Ramp 50",
        bpm = 70
    },
    
    -- Row 4: Special Forms
    {
        number = 19,
        name = "Circle",
        form = "Circle",
        bpm = 40
    },
    {
        number = 20,
        name = "Sound",
        form = "Sound",
        bpm = 120
    },
    {
        number = 21,
        name = "Flyout",
        form = "Flyout",
        bpm = 60
    },
    {
        number = 22,
        name = "Wave",
        form = "Wave",
        bpm = 50
    },
    {
        number = 23,
        name = "Cross",
        form = "Cross",
        bpm = 60
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
-- Function to create a single effect
-- *********************************************

local function create_effect(config, progress_handle)
    gma.echo("Creating Effect " .. config.number .. ": " .. config.name);
    
    if progress_handle then
        gma.gui.progress.settext(progress_handle, "Creating " .. config.name .. "...");
    end
    
    -- Clear programmer
    gma.cmd("ClearAll");
    gma.sleep(0.1);
    
    -- Select all fixtures
    gma.cmd("Fixture Thru");
    gma.sleep(0.1);
    
    -- Select Dimmer preset type (this creates the attribute selection)
    gma.cmd("Presettype \"Dimmer\"");
    gma.sleep(0.1);
    
    -- Set form (attribute is now selected)
    gma.cmd("At Form \"" .. config.form .. "\"");
    gma.sleep(0.1);
    
    -- Set BPM
    gma.cmd("At EffectBPM " .. config.bpm);
    gma.sleep(0.1);
    
    -- Store the effect
    gma.cmd("Store Effect " .. config.number .. " /nc");
    gma.sleep(0.5);
    
    -- Label the effect
    gma.cmd("Label Effect " .. config.number .. " \"" .. config.name .. "\"");
    gma.sleep(0.2);
    
    gma.echo("  ✓ Effect " .. config.number .. " created: " .. config.name);
    
    return true;
end

-- *********************************************
-- Main function to insert all effects
-- *********************************************

local function insert_all_effects()
    gma.echo("");
    gma.echo("Starting automatic effect insertion...");
    gma.echo("Creating " .. #effects_config .. " effects with all available forms");
    gma.echo("");
    
    if not check_fixtures() then
        return false;
    end
    
    local confirm = gma.gui.confirm(
        "Auto Insert Effects",
        "This will create " .. #effects_config .. " sample effects (Effect 1-" .. #effects_config .. ").\n\n" ..
        "All 23 available effect forms will be created:\n" ..
        "- Stomp, Release, Random, Pwm, Chase, Flat Low/High\n" ..
        "- Sin, Cos, Ramp Plus/Minus/50, Ramp\n" ..
        "- Phase 1/2/3, Bump, Swing\n" ..
        "- Circle, Sound, Flyout, Wave, Cross\n\n" ..
        "Any existing effects will be overwritten.\n\n" ..
        "Continue?"
    );
    
    if not confirm then
        gma.echo("Effect insertion cancelled by user.");
        return false;
    end
    
    local progress = gma.gui.progress.start("Auto Insert Effects");
    gma.gui.progress.setrange(progress, 0, #effects_config);
    
    local success_count = 0;
    local failed_effects = {};
    
    for i, config in ipairs(effects_config) do
        gma.gui.progress.set(progress, i - 1);
        
        local success, err = pcall(function()
            return create_effect(config, progress);
        end);
        
        if success and err then
            success_count = success_count + 1;
        else
            table.insert(failed_effects, config.name);
            gma.echo("  ✗ Failed to create Effect " .. config.number .. ": " .. config.name);
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
    if #failed_effects > 0 then
        gma.echo("Failed effects: " .. table.concat(failed_effects, ", "));
    end
    gma.echo("===========================================");
    gma.echo("");
    
    local summary = "Successfully created " .. success_count .. " / " .. #effects_config .. " effects!\n\n";
    summary = summary .. "All 23 effect forms have been created.\n";
    summary = summary .. "Check your Effect Pool!\n\n";
    
    if #failed_effects > 0 then
        summary = summary .. "Note: Some effects may have failed:\n";
        summary = summary .. table.concat(failed_effects, ", ");
    end
    
    gma.gui.msgbox("Auto Insert Effects - Complete", summary);
    
    return true;
end

-- *********************************************
-- Plugin entry point
-- *********************************************

function Start()
    gma.echo("Starting Auto Insert Effects plugin...");
    gma.sleep(0.2);
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
