-- *********************************************
-- Auto Insert Effects Shape Plugin v1.0
-- Creates Pan/Tilt shape effects with predefined configurations
-- Smart Macros - Effects created on-demand
-- *********************************************

local internal_name = select(1,...);
local visible_name = select(2,...);

gma.echo("===========================================");
gma.echo("Auto Insert Effects Shape Plugin v1.0");
gma.echo("Pan/Tilt Circle & Movement Effects");
gma.echo("Smart Macros - Effects created on-demand");
gma.echo("===========================================");

-- *********************************************
-- Configuration: 12 Pan/Tilt Shape Effects
-- *********************************************

local effects_config = {
    -- PT CIRCLE EFFECTS (Macro 1-4)
    {
        number = 1, 
        name = "fx Circle 1", 
        type = "circle",
        pan_form = 8,      -- Sin
        tilt_form = 9,     -- Cos
        phase = "0 Thru 90",
        wing = "-2 Thru 2",
        bpm = 40
    },
    {
        number = 2, 
        name = "fx Circle 2", 
        type = "circle",
        pan_form = 8,      -- Sin
        tilt_form = 9,     -- Cos
        phase = "0 Thru 90",
        wing = "-4 Thru 4",
        bpm = 40
    },
    {
        number = 3, 
        name = "fx Circle 3", 
        type = "circle",
        pan_form = 8,      -- Sin (default)
        tilt_form = 9,     -- Cos (default)
        phase = "0 Thru 360",
        wing = "-2 Thru 2",
        bpm = 40
    },
    {
        number = 4, 
        name = "fx Circle 4", 
        type = "circle",
        pan_form = 8,      -- Sin
        tilt_form = 9,     -- Cos
        phase = "90",
        wing = "-2 Thru 2",
        bpm = 40
    },
    
    -- PAN ONLY EFFECTS (Macro 5-8)
    {
        number = 5, 
        name = "fx Pan Sym 1", 
        type = "pan_only",
        attribute = "Pan",
        form = 8,          -- Sin
        phase = "0 Thru 90",
        wing = "-2 Thru 2",
        symmetric = true,
        bpm = 60
    },
    {
        number = 6, 
        name = "fx Pan Sym 2", 
        type = "pan_only",
        attribute = "Pan",
        form = 8,          -- Sin
        phase = "0 Thru 180",
        wing = "-3 Thru 3",
        symmetric = true,
        bpm = 60
    },
    {
        number = 7, 
        name = "fx Pan NonSym 1", 
        type = "pan_only",
        attribute = "Pan",
        form = 8,          -- Sin
        phase = "0 Thru 360",
        wing = "-2 Thru 2",
        symmetric = false,
        bpm = 60
    },
    {
        number = 8, 
        name = "fx Pan NonSym 2", 
        type = "pan_only",
        attribute = "Pan",
        form = 10,         -- Ramp Plus
        phase = "0 Thru 180",
        wing = "-4 Thru 4",
        symmetric = false,
        bpm = 70
    },
    
    -- TILT ONLY EFFECTS (Macro 9-12)
    {
        number = 9, 
        name = "fx Tilt Sym 1", 
        type = "tilt_only",
        attribute = "Tilt",
        form = 9,          -- Cos
        phase = "0 Thru 90",
        wing = "-2 Thru 2",
        symmetric = true,
        bpm = 60
    },
    {
        number = 10, 
        name = "fx Tilt Sym 2", 
        type = "tilt_only",
        attribute = "Tilt",
        form = 9,          -- Cos
        phase = "0 Thru 180",
        wing = "-3 Thru 3",
        symmetric = true,
        bpm = 60
    },
    {
        number = 11, 
        name = "fx Tilt NonSym 1", 
        type = "tilt_only",
        attribute = "Tilt",
        form = 9,          -- Cos
        phase = "0 Thru 360",
        wing = "-2 Thru 2",
        symmetric = false,
        bpm = 60
    },
    {
        number = 12, 
        name = "fx Tilt NonSym 2", 
        type = "tilt_only",
        attribute = "Tilt",
        form = 10,         -- Ramp Plus
        phase = "0 Thru 180",
        wing = "-4 Thru 4",
        symmetric = false,
        bpm = 70
    }
};

-- *********************************************
-- Function to create PT Circle effect macro
-- *********************************************

local function create_circle_macro(macro_number, config)
    gma.echo("Creating PT Circle macro " .. macro_number .. ": " .. config.name);
    
    -- Store the macro
    gma.cmd("Store Macro 1." .. macro_number .. " /nc");
    
    local line_num = 1
    
    -- Line 1: ClearAll
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"ClearAll\"");
    line_num = line_num + 1
    
    -- Line 2: Fixture Thru
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Fixture Thru\"");
    line_num = line_num + 1
    
    -- Line 3: Presettype Pan
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Presettype Pan\"");
    line_num = line_num + 1
    
    -- Line 4: At Form for Pan (Sin)
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At Form " .. config.pan_form .. "\"");
    line_num = line_num + 1
    
    -- Line 5: Presettype Tilt
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Presettype Tilt\"");
    line_num = line_num + 1
    
    -- Line 6: At Form for Tilt (Cos)
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At Form " .. config.tilt_form .. "\"");
    line_num = line_num + 1
    
    -- Line 7: At EffectBPM
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At EffectBPM " .. config.bpm .. "\"");
    line_num = line_num + 1
    
    -- Line 8: At EffectPhase
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At EffectPhase " .. config.phase .. "\"");
    line_num = line_num + 1
    
    -- Line 9: At EffectWing
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At EffectWing " .. config.wing .. "\"");
    line_num = line_num + 1
    
    -- Line 10: Store Effect
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Store Effect /nc /o\"");
    line_num = line_num + 1
    
    -- Line 11: Label Effect
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Label Effect \\\"" .. config.name .. "\\\"\"");
    line_num = line_num + 1
    
    -- Line 12: ClearAll
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"ClearAll\"");
    
    gma.echo("  ✓ PT Circle macro " .. macro_number .. " created");
    
    -- Label the macro
    gma.cmd("Label Macro " .. macro_number .. " \"" .. config.name .. "\"");
    
    return true;
end

-- *********************************************
-- Function to create Pan/Tilt only effect macro
-- *********************************************

local function create_single_axis_macro(macro_number, config)
    gma.echo("Creating " .. config.attribute .. " macro " .. macro_number .. ": " .. config.name);
    
    -- Store the macro
    gma.cmd("Store Macro 1." .. macro_number .. " /nc");
    
    local line_num = 1
    
    -- Line 1: ClearAll
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"ClearAll\"");
    line_num = line_num + 1
    
    -- Line 2: Fixture Thru
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Fixture Thru\"");
    line_num = line_num + 1
    
    -- Line 3: Presettype (Pan or Tilt)
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Presettype " .. config.attribute .. "\"");
    line_num = line_num + 1
    
    -- Line 4: At Form
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At Form " .. config.form .. "\"");
    line_num = line_num + 1
    
    -- Line 5: At EffectBPM
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At EffectBPM " .. config.bpm .. "\"");
    line_num = line_num + 1
    
    -- Line 6: At EffectPhase
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At EffectPhase " .. config.phase .. "\"");
    line_num = line_num + 1
    
    -- Line 7: At EffectWing
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"At EffectWing " .. config.wing .. "\"");
    line_num = line_num + 1
    
    -- Line 8: Store Effect
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Store Effect /nc /o\"");
    line_num = line_num + 1
    
    -- Line 9: Label Effect
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"Label Effect \\\"" .. config.name .. "\\\"\"");
    line_num = line_num + 1
    
    -- Line 10: ClearAll
    gma.cmd("Store Macro 1." .. macro_number .. "." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1." .. macro_number .. "." .. line_num .. " /cmd=\"ClearAll\"");
    
    gma.echo("  ✓ " .. config.attribute .. " macro " .. macro_number .. " created");
    
    -- Label the macro
    gma.cmd("Label Macro " .. macro_number .. " \"" .. config.name .. "\"");
    
    return true;
end

-- *********************************************
-- Function to create PT Circle effect directly
-- *********************************************

local function create_circle_effect(config)
    gma.echo("Creating PT Circle effect: " .. config.name);
    
    -- ClearAll
    gma.cmd("ClearAll");
    
    -- Fixture Thru
    gma.cmd("Fixture Thru");
    
    -- Presettype Pan
    gma.cmd("Presettype Pan");
    
    -- At Form for Pan (Sin)
    gma.cmd("At Form " .. config.pan_form);
    
    -- Presettype Tilt
    gma.cmd("Presettype Tilt");
    
    -- At Form for Tilt (Cos)
    gma.cmd("At Form " .. config.tilt_form);
    
    -- At EffectBPM
    gma.cmd("At EffectBPM " .. config.bpm);
    
    -- At EffectPhase
    gma.cmd("At EffectPhase " .. config.phase);
    
    -- At EffectWing
    gma.cmd("At EffectWing " .. config.wing);
    
    -- Store Effect
    gma.cmd("Store Effect /nc /o");
    
    -- Label Effect
    gma.cmd("Label Effect \"" .. config.name .. "\"");
    
    -- ClearAll
    gma.cmd("ClearAll");
    
    gma.echo("  ✓ PT Circle effect created: " .. config.name);
    
    return true;
end

-- *********************************************
-- Function to create Pan/Tilt only effect directly
-- *********************************************

local function create_single_axis_effect(config)
    gma.echo("Creating " .. config.attribute .. " effect: " .. config.name);
    
    -- ClearAll
    gma.cmd("ClearAll");
    
    -- Fixture Thru
    gma.cmd("Fixture Thru");
    
    -- Presettype (Pan or Tilt)
    gma.cmd("Presettype " .. config.attribute);
    
    -- At Form
    gma.cmd("At Form " .. config.form);
    
    -- At EffectBPM
    gma.cmd("At EffectBPM " .. config.bpm);
    
    -- At EffectPhase
    gma.cmd("At EffectPhase " .. config.phase);
    
    -- At EffectWing
    gma.cmd("At EffectWing " .. config.wing);
    
    -- Store Effect
    gma.cmd("Store Effect /nc /o");
    
    -- Label Effect
    gma.cmd("Label Effect \"" .. config.name .. "\"");
    
    -- ClearAll
    gma.cmd("ClearAll");
    
    gma.echo("  ✓ " .. config.attribute .. " effect created: " .. config.name);
    
    return true;
end

-- *********************************************
-- Main function to create ONE master macro
-- *********************************************

local function create_master_macro()
    gma.echo("");
    gma.echo("===========================================");
    gma.echo("Creating Master Shape Effect Macro...");
    gma.echo("Total effects: " .. #effects_config);
    gma.echo("===========================================");
    gma.echo("");
    
    -- Store the master macro
    gma.cmd("Store Macro 1.1 /nc");
    gma.echo("Creating master macro...");
    
    local line_num = 1;
    
    -- Line 1: Confirmation prompt using Lua
    gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
    local confirm_lua = "local c=gma.gui.confirm('Generate Effects','Generate ALL 12 Pan/Tilt shape effects?');if not c then return end";
    gma.cmd("Assign Macro 1.1." .. line_num .. " /lua=\"" .. confirm_lua .. "\"");
    line_num = line_num + 1;
    
    -- Generate all 12 effects
    for i, config in ipairs(effects_config) do
        -- ClearAll
        gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
        gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"ClearAll\"");
        line_num = line_num + 1;
        
        -- Fixture Thru
        gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
        gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"Fixture Thru\"");
        line_num = line_num + 1;
        
        if config.type == "circle" then
            -- Attribute Pan
            gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
            gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"Attribute Pan\"");
            line_num = line_num + 1;
            
            -- At Form for Pan
            gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
            gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"At Form " .. config.pan_form .. "\"");
            line_num = line_num + 1;
            
            -- Attribute Tilt
            gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
            gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"Attribute Tilt\"");
            line_num = line_num + 1;
            
            -- At Form for Tilt
            gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
            gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"At Form " .. config.tilt_form .. "\"");
            line_num = line_num + 1;
        else
            -- Attribute (Pan or Tilt)
            gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
            gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"Attribute " .. config.attribute .. "\"");
            line_num = line_num + 1;
            
            -- At Form
            gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
            gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"At Form " .. config.form .. "\"");
            line_num = line_num + 1;
        end
        
        -- At EffectBPM
        gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
        gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"At EffectBPM " .. config.bpm .. "\"");
        line_num = line_num + 1;
        
        -- At EffectPhase
        gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
        gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"At EffectPhase " .. config.phase .. "\"");
        line_num = line_num + 1;
        
        -- At EffectWing
        gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
        gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"At EffectWing " .. config.wing .. "\"");
        line_num = line_num + 1;
        
        -- Store Effect
        gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
        gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"Store Effect /nc /o\"");
        line_num = line_num + 1;
        
        -- Label Effect
        gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
        gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"Label Effect \\\"" .. config.name .. "\\\"\"");
        line_num = line_num + 1;
    end
    
    -- Final ClearAll
    gma.cmd("Store Macro 1.1." .. line_num .. " /nc");
    gma.cmd("Assign Macro 1.1." .. line_num .. " /cmd=\"ClearAll\"");
    
    -- Label the master macro
    gma.cmd("Label Macro 1 \"Generate All Shape FX\"");
    
    gma.cmd("ClearAll");
    
    gma.echo("");
    gma.echo("===========================================");
    gma.echo("Master macro created successfully!");
    gma.echo("Macro 1: Generate All Shape FX");
    gma.echo("Total command lines: " .. line_num);
    gma.echo("===========================================");
    gma.echo("");
    
    gma.echo("✅ Macro created! Click Macro 1 to generate all 12 effects.");
    
    return true;
end

-- *********************************************
-- Plugin entry point
-- *********************************************

function Start()
    gma.echo("Starting Auto Insert Effects Shape plugin...");
    create_master_macro();
end

-- *********************************************
-- Cleanup function
-- *********************************************

function Cleanup()
    gma.echo("Auto Insert Effects Shape plugin cleanup called");
end

-- *********************************************
-- Return entry and cleanup functions
-- *********************************************

return Start, Cleanup;
