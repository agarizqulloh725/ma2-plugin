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
-- Function to find next empty effect slot
-- *********************************************

local function find_next_empty_slot(start_number)
    local current = start_number;
    local max_attempts = 1000; -- Prevent infinite loop
    local attempts = 0;
    
    while attempts < max_attempts do
        local effect_handle = gma.show.getobj.handle("Effect " .. current);
        if not effect_handle then
            -- Slot is empty
            return current;
        end
        current = current + 1;
        attempts = attempts + 1;
    end
    
    -- If we couldn't find empty slot
    return nil;
end

-- *********************************************
-- Function to get start number from user
-- *********************************************

local function get_start_number()
    local input = gma.textinput("Start Effect Number", "Enter starting effect number (will find empty slots):");
    
    if not input or input == "" then
        gma.echo("No start number provided, using default: 1");
        return 1;
    end
    
    local start_num = tonumber(input);
    
    if not start_num or start_num < 1 then
        gma.gui.msgbox("Invalid Input", "Please enter a valid positive number. Using default: 1");
        return 1;
    end
    
    return math.floor(start_num);
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
    
    -- Get start number from user
    local start_number = get_start_number();
    gma.echo("Starting from effect number: " .. start_number);
    gma.echo("");
    
    local confirm = gma.gui.confirm(
        "Auto Insert Effects",
        "This will create " .. #effects_config .. " sample effects starting from Effect " .. start_number .. ".\n\n" ..
        "All 23 available effect forms will be created:\n" ..
        "- Stomp, Release, Random, Pwm, Chase, Flat Low/High\n" ..
        "- Sin, Cos, Ramp Plus/Minus/50, Ramp\n" ..
        "- Phase 1/2/3, Bump, Swing\n" ..
        "- Circle, Sound, Flyout, Wave, Cross\n\n" ..
        "Effects will be placed in EMPTY SLOTS only.\n" ..
        "Existing effects will NOT be overwritten.\n\n" ..
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
    local used_slots = {};
    local current_search_start = start_number;
    
    for i, config in ipairs(effects_config) do
        gma.gui.progress.set(progress, i - 1);
        
        -- Find next empty slot
        local empty_slot = find_next_empty_slot(current_search_start);
        
        if not empty_slot then
            gma.echo("  ✗ Could not find empty slot for: " .. config.name);
            table.insert(failed_effects, config.name .. " (no empty slot)");
        else
            -- Update config with the empty slot number
            config.number = empty_slot;
            table.insert(used_slots, empty_slot);
            
            -- Create the effect
            local success, err = pcall(function()
                return create_effect(config, progress);
            end);
            
            if success and err then
                success_count = success_count + 1;
                -- Start searching from next number
                current_search_start = empty_slot + 1;
            else
                table.insert(failed_effects, config.name);
                gma.echo("  ✗ Failed to create Effect " .. config.number .. ": " .. config.name);
            end
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
    gma.echo("Effects placed in slots: " .. table.concat(used_slots, ", "));
    if #failed_effects > 0 then
        gma.echo("Failed effects: " .. table.concat(failed_effects, ", "));
    end
    gma.echo("===========================================");
    gma.echo("");
    
    local summary = "Successfully created " .. success_count .. " / " .. #effects_config .. " effects!\n\n";
    summary = summary .. "All 23 effect forms have been created.\n";
    summary = summary .. "Effects placed in slots:\n" .. table.concat(used_slots, ", ") .. "\n\n";
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
