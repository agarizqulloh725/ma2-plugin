-- Delay Sweeps Generator - Installer
-- v1.8.1

-- Created by Jason Giaffo
-- Last updated May 30, 2019
-- Contact: http://giaffodesigns.com/contact/
                                                                                                                                                                                                                                                                                                                                                                    local userconfig = {}
-- All copies and revisions of this code are copyright property of Giaffo Designs and may not be used, in any part or in entirety, without written consent of Jason Giaffo and credit where used. This plugin is only approved for usage by persons who have directly purchased it from GiaffoDesigns.
-- TL;DR: don't be a dick; don't steal people's work; give credit to people





---- User Config ----
userconfig.delaytime_list = {0, 0.25, 0.5, 1, 2, 4} --enter each sweep-time value between the brackets, separated by a comma

userconfig.chaserWings = false  --values: true, false; do not use quotes
                                --doubles "wavelength" (halves fadetime) for wings for consistent distance between unidirectional and bidirectional sweeps across rig;


userconfig.target_range = {     -- included are only samples; these are the targets intended for the delay sweeps to be implemented on; type them exactly as you would into the command line
    [[Executor *."*_col" Cue *]],
    [[Sequence "*COLORS*" Cue *]],
    [[Executor 1.1 thru 30 Cue *]],
}
                            
                            



--Preset Type Information
userconfig.presetTypes   = {0}     -- enter 0 for all preset types to be included; to apply to multiple types, enter multiple numbers between {} brackets, separated by a comma
                                   -- example: {1, 2, 4} would mean the delays only affect dimmer, position, and color information


--Storage Information
userconfig.macStart_target    = 1000    --fist macro storage slot; will advance to next sufficient space if not enough room
userconfig.pluginStart_target = 50      --plugin pool space where generated plugin(s) will be stored
userconfig.presetStart_target = 500     --first 'All' preset pool item to be stored to





















-------------------------------------------------------------------------------------------
------------------------------ DO NOT EDIT BELOW THIS POINT --------------------------------
--------------------------------------------------------------------------------------------


--SHORTCUT VARIABLES--
local cmd = gma.cmd
local text = gma.textinput
local print = gma.echo
local getHandle = gma.show.getobj.handle
local unpack = table.unpack

---- LOCAL FUNCTIONS ----
function getClass(str)
  return gma.show.getobj.class(getHandle(str))
end

function trunc(num, mod)
  local x = num - (num%mod)
  return x
end

function macStore(macroNum, label)
  gma.cmd('Store Macro 1.'..macroNum) --create macro
  gma.cmd('Label Macro 1.'..macroNum..' \"'..label..'\"') --label the macro
end



function macLine (macroNum, lineNum, command, wait)
  cmd('Store Macro 1.'..macroNum..'.'..lineNum)
  cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/cmd = \"'..command..'\"')
  if wait then cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/wait = \"'..wait..'\"') end
end



function textCheck(barText, dialogueText, loop, numberonly)
  local dialogueList = {dialogueText, 'invalid input: please enter numbers only'}
  local x = 1
  
  local t
  local validStatus = false
  while validStatus == false do
    t = gma.textinput(barText, dialogueList[x])
    if t == nil then break                       --functions for empty input
    elseif t == dialogueList[x] then
      if loop ~= true then --false will make an empty input signal end of function
        t = nil             --true will skip this if statement so the function can loop
        break
      end
    end
      
    if numberonly == true then --in case only number input is wanted but a normal string has been entered
      if tonumber(t) ~= nil then
        validStatus = true
      else
        x = 2
      end
    else validStatus = true
    end
  end
  return t
end



function checkSpace(poolType, start, length) --checks if range of pool spaces is empty
  local finish = start + length - 1 --set our finishing point
  local emptyStatus = true
  for i = start, finish do
    if getClass(poolType..' '..tostring(i)) then --if space is not empty
      emptyStatus = false
      break
    end
  end
  return emptyStatus
end



local function advanceSpace(poolType, start, length, pad_before, pad_after)
    --new version, has checkSpace() function embedded, padding added
    --padding parameters are optional; default to 0 if not provided
    
    local function checkSpace(poolType, start, length) --checks if range of pool spaces is empty
      local finish = start + length - 1 --set our finishing point
      local emptyStatus = true
      for i = start, finish do
        if getClass(poolType..' '..tostring(i)) then --if space is not empty
          emptyStatus = false
          break
        end
      end
      return emptyStatus
    end

    local pad_before    = pad_before    or 0                            --set for 0 if not provided
    local pad_after        = pad_after        or 0                            --set for 0 if not provided
    pad_before, pad_after = math.abs(pad_before), math.abs(pad_after)
    local length_actual = length + pad_before + pad_after                --length that will be used in space check
    
    local finalStart = start
    while checkSpace(poolType, finalStart, length_actual) == false do
        finalStart = finalStart + 1
    end
  
    finalStart = finalStart + pad_before                                --offset returned answer for pre-padding
    return finalStart
end



function getGroup(grpNum)
  gma.cmd('SelectDrive 1') --select the internal drive
  
  local file = {}
  file.name = 'tempfile_getgroup.xml' 
  file.directory = gma.show.getvar('PATH')..'/'..'importexport'..'/'
  file.fullpath = file.directory..file.name
  
  gma.cmd('Export Group ' .. grpNum .. ' \"' .. file.name .. '\"') -- create temporary file
  
  local t = {}  --convert XML file into a table
  for line in io.lines(file.fullpath) do
    t[#t + 1] = line
  end
  os.remove(file.fullpath) --delete temporary file
  
  local groupList = {} --declare groupList
  for i = 1, #t do
    if t[i]:find('Subfixture ') then
      local indices = {t[i]:find('\"%d+\"')} --find points of quotation marks
      indices[1], indices[2] = indices[1] + 1, indices [2] - 1 --move reference points to first an last characters inside those marks
      
      --label based on status as a fixture or as a channel
      local fixture
      if t[i]:find('fix_id') then
        fixture = 'Fixture ' .. tostring(t[i]:sub(indices[1], indices[2])) --extract the number as the fixture number
      elseif t[i]:find('cha_id') then
        fixture = 'Channel ' .. tostring(t[i]:sub(indices[1], indices[2])) end --extract the number as the fixture number
        
      --if the object contains a subfixture...
      if t[i]:find('sub_index') then
        local indices = {t[i]:find('\"%d+\"', indices[2]+2)}
        indices[1], indices[2] = indices[1] + 1, indices[2] - 1
        fixture = fixture .. '.' .. tostring(t[i]:sub(unpack(indices)))
      end
      
      --append to list
      groupList[#groupList + 1] = fixture --extract the number to the group list
    end
  end
  
  return groupList
end

function createPlugin(num, name, script, EOL)

  -- establish if plugin will Execute On Load --
  local EOLnum
  if EOL then EOLnum = 1 
  else EOLnum = 0 end
  
  -- Establish filepath --
  cmd('SelectDrive 1') --select internal drive as default access path
  
  local plugin = {}
  plugin.name = 'tempfile_createplugin'
  plugin.directory = gma.show.getvar('PLUGINPATH')..'/'
  plugin.fullpathLUA = plugin.directory..plugin.name..'.lua'
  plugin.fullpathXML = plugin.directory..plugin.name..'.xml'


  -- Create text for plugin XML file --
  local xmlText = [[
<?xml version="1.0" encoding="utf-8"?>
<MA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.malighting.de/grandma2/xml/MA" xsi:schemaLocation="http://schemas.malighting.de/grandma2/xml/MA http://schemas.malighting.de/grandma2/xml/3.2.2/MA.xsd" major_vers="3" minor_vers="2" stream_vers="2">
    <Info datetime="2016-09-26T20:40:54" showfile="dummyfile" />
    <Plugin index="1" execute_on_load="]]..EOLnum..[[" name="]]..name..[[" luafile="]]..plugin.name..[[.lua" />
</MA>]]

  -- Write XML file to disk --
  local fileXML = assert(io.open(plugin.fullpathXML, 'w'))
  fileXML:write(xmlText)
  fileXML:close()
  
  -- Write LUA file to disk --
  local fileLUA = assert(io.open(plugin.fullpathLUA, 'w'))
  fileLUA:write(script)
  fileLUA:close()


  -- import plugin --
  cmd('Import \"'..plugin.name..'.xml'..'\" Plugin '..tostring(num)) --load new plugin into showfile

  -- delete temp files --
  os.remove(plugin.fullpathXML)
  os.remove(plugin.fullpathLUA)
end



local function confirm(title, message_box, message_text)
  -- v. 1.0
  -- function avoids using confirmation box function with version 3.1.2.5, which crashes the software
  local confirm_method
  
  local version = gma.show.getvar('version')
  
  if version:find('3.1.2') == 1 then 
    confirm_method = 'textinput'
  else 
    confirm_method = 'box' end
  
  if confirm_method == 'box' then
    return gma.gui.confirm(title, message_box)
  elseif confirm_method == 'textinput' then
    local t = gma.textinput(title, message_text)
    if t then t = true end
    return t
  end
end



local function msgbox(title, message_box, message_text)
  -- v. 1.0
  -- function avoids using confirmation box function with version 3.1.2.5, where it doesn't exist
  local confirm_method
  
  local version = gma.show.getvar('version')
  
  if version:find('3.1.2') == 1 then 
    confirm_method = 'textinput'
  else 
    confirm_method = 'box' end
  
  if confirm_method == 'box' then
    gma.gui.msgbox(title, message_box)
  elseif confirm_method == 'textinput' then
    gma.textinput(title, message_text)
  end
end




---- CLASSES ----
local ProgressBar = {
  value = 0,

  new = function(self, name)
      o = {handle = gma.gui.progress.start(name)}

      setmetatable(o, self)
      self.__index = self
      return o
  end,
  
  set = function(self, num, add)
      if add then num = self.value + num end
      
      num = math.floor(num)
      gma.gui.progress.set(self.handle, num)
      self.value = num
  end,
  
  setrange = function(self, bottom, top)
      if not bottom or not top then return nil end
      gma.gui.progress.setrange(self.handle, bottom, top)
      self.range = {top = top, bottom = bottom}
  end,
  
  settext = function(self, text)
      gma.gui.progress.settext(self.handle, text)
  end,
  
  rename = function(self, name)
      gma.gui.progress.stop(self.handle)
      self.handle = gma.gui.progress.start(name)
      if self.range then gma.gui.progress.setrange(self.handle, self.range.bottom, self.range.top) end
  end,
  
  stop = function(self)
      gma.gui.progress.stop(self.handle)
  end,
  
  time_move = function(self, target, time, add, ignore_top)
      if add then target = self.value + target end
      local start = self.value
      local finish = math.floor(target)
      
      local sleepPeriod
      if math.abs(time) ~= time then sleepPeriod = (1 / time)                                            --allow for negative time values to trigger a "rate" function
      else sleepPeriod = time / (math.abs(finish - start)) end
      
      if not ignore_top and self.range and finish > self.range.top then finish = self.range.top end    --set finish point to top of progress-bar range unless specified to ignore
      
      local dir = 1
      if start > finish then dir = -1 end
      
      for i = start, finish, dir do
          self:set(i)
          gma.sleep(sleepPeriod)
      end    
  end
}





local ST = {
  append = function(self, v)
      self[#self + 1] = v
  end,

  concat = function(self, sep, i, j)
      return table.concat(self, sep, i, j)
  end,
  
  new = function(self, o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      return o
  end,

  shuffle = function(list)
      local iterations = #list
      for x = 1, 4 do                                --repeat process, else last number ends up the same
          for i = iterations, 1, -1 do
              j = math.random(i)
              list[i], list[j] = list[j], list[i]
          end
      end
  end
}









































-- linking to previous variables
local presetTypes = userconfig.presetTypes
local delaytime_list = userconfig.delaytime_list
local chaserWings = userconfig.chaserWings
local create_updater = true



local macStart_target    = userconfig.macStart_target
local pluginStart_target = userconfig.pluginStart_target
local presetStart_target = userconfig.presetStart_target








--------------------------------------------------------------------------------------
----------------------------------- START OF PLUGIN ----------------------------------
--------------------------------------------------------------------------------------
local pBars = ST:new{}

local function main()

if type(presetTypes) ~= 'table' then presetTypes = {tonumber(presetTypes)} end


---- Check that user has set/checked their User Config settings ----
local mt = ST:new{'DELAY TIMES TO USE:\n'..table.concat(userconfig.delaytime_list, ', ')}
mt:append('\n')
mt:append('CHASERWINGS ACTIVE: '..tostring(userconfig.chaserWings))
mt:append('\n')
mt:append('TARGET RANGE(S):\n'..table.concat(userconfig.target_range, '\n'))
mt:append('\n')
mt:append('Click \"OK\" to Continue, \"Cancel\" to stop plugin')
local msg = table.concat(mt, '\n')
local t = confirm('Settings Checked?', msg, 'Press Enter to continue. Click X to stop plugin.')
if (not t) then goto EOF end



---- Convert User-Config entries to usable values for later use ----
-- chaser wings
local chaserWings_mult = 1
if chaserWings then chaserWings_mult = 0.5 end

-- execution plugin storage slot
local pluginSlot_execution, pluginSlot_updater
local plugin_length = 2                       -- execution plugin + updater plugin

pluginSlot_execution = advanceSpace('Plugin', pluginStart_target, plugin_length)
pluginSlot_updater = pluginSlot_execution + 1


-- name of preset type
local pTypeNames = {'Dimmer', 'Position', 'Gobo', 'Color', 'Beam', 'Focus', 'Control', 'Shapers', 'Video'};
pTypeNames[0] = 'Dly'

local delaySweep_type = string.upper(pTypeNames[presetTypes[1]])
 
-- string of preset-types for later use
-- local pTypes_str = tostring(presetTypes[1])
-- for i = 2, #presetTypes do
--     pTypes_str = pTypes_str..' + '..tostring(presetTypes[i])
-- end

local pTypes_str = table.concat(presetTypes, ' + ')

local pTypes_str_update = tostring(presetTypes[1])
for i = 2, #presetTypes do
    pTypes_str_update = pTypes_str_update..', '..tostring(presetTypes[i])
end


-- Obtain installation ID and system variable names
local delaySweep_id = 1
local match_empty = false

-- run collision-check script for delaySweep_id, in the event that the plugin has already been installed on a previous set of fixtures/preset types
if delaySweep_execPlugins then
  while match_empty == false do
    match_empty = true
    
    --check against each existing value; bump up by 1 and repeat loop if collision found
    --done this way instead of finding last value and +=1 to avoid large numbers over time on the same showfile
    for k, v in pairs(delaySweep_execPlugins) do 
      if (v.id == delaySweep_id) and (v.type == delaySweep_type) then 
        match_empty = false
        delaySweep_id = delaySweep_id + 1
      end
    end
  end
end


---- Set system variable name ----
local varName = delaySweep_type
if delaySweep_id > 1 then varName = varName..tostring(delaySweep_id) end



--OBTAIN ROW POSITIONS
local endMessage = '[HIT ENTER W/O INPUT WHEN DONE]'
local rows = {}
local x = 1 --will determine which displayMessage to use if more than one
local loopct = 1

while true do  
  local displayMessage
  if loopct == 1 then displayMessage = {'DS Group #'}
  else displayMessage = {'Row '..loopct..' Group #'} end
  
  local t = text(displayMessage[x], endMessage)
  if tonumber(t) then
    rows[loopct] = tonumber(t)
    loopct = loopct + 1
  elseif t == nil then
    goto EOF
  elseif t == endMessage then
    break
  end
end

--Generate Group Arrays--
local groups = {}       --groups[group][fixture]
for i = 1, #rows do
  groups[i] = getGroup(rows[i]) --push each group into individual fixtures in group array
end



------------------------------------------------------------------------------------
---------------------------- GENERATE DIVISION ARRAYS ------------------------------
------------------------------------------------------------------------------------


local divisions = {} --format: divisions[direction][group][fixture proportion (on 1 and 2 only)]
for i = 1, 4 do
  divisions[i] = {} --declare nested lists for each direction array
end



---- Generate Division Arrays: Vertical Straight (divisions[3]) ----
if (#groups > 1) then
  local divCt = #groups - 1
  local interval = 1 / divCt
  local proportion = 0
  for grp = 1, #groups do
    divisions[3][grp] = proportion
    proportion = proportion + interval
  end
else
  divisions[3][1] = 0
end

---- Generate Division Arrays: Vertical Wings (divisions[4]) ----
--- LIST IS HALF LENGTH OF GROUP - ACCOUNTED FOR IN PRESET CREATION PORTION OF SCRIPT ---
if (#groups > 2) then
  local divCt = math.ceil(#groups/2) - 1
  local interval = chaserWings_mult / divCt
  local proportion = chaserWings_mult --working backwards so the default direction of this array will be center-out

  for grp = 1, (divCt + 1) do
    divisions[4][grp] = proportion
    proportion = proportion - interval
  end
  
else --in case groups are less than 3 objects long, make delay times 0 (no possible way to fan in or out without at least 3 rows)
  for i = 1, #groups do
    divisions[4][i] = 0
  end
end




------------------------------------------------------------------------------------
-------------------------------- DELAY TIMES ---------------------------------------
------------------------------------------------------------------------------------

--GENERATE AND POPULATE LIST OF DELAY TIMES

local timeList = delaytime_list


------------------------------------------------------------------------------------

local timeCt = 0
---- Time Arrays ----
local divisionTimes = {} --format: divisionTimes[direction][time][group][fixture]; only used for vertical presets now
--divisionTimes[1] and [2]


---- Vertical Time Arrays ----
for dir = 3, 4 do
    divisionTimes[dir] = {} --declare array
    for time = 1, #timeList do
      divisionTimes[dir][time] = {} --declare array
      for grp = 1, #divisions[dir] do
        divisionTimes[dir][time][grp] = timeList[time] * divisions[dir][grp] --time * (group proportion value)
        timeCt = timeCt + 1
      end
    end
end

timeCt = timeCt*2 + (#timeList * 5)                                           -- not entirely sure why it's written like this but not going to mess with it right now
--timeCt = (#timeList * #rows * 4)  + (#timeList * 4)


------------------------------------------------------------------------------------
------------------------- CONVERT TIMES TO PRESETS ---------------------------------
------------------------------------------------------------------------------------

gma.cmd('BlindEdit On')
gma.cmd('Highlight Off') --make sure highlight values don't somehow get caught in presets

---- Check for Space ----
local presetCt = 0
local presetStart = presetStart_target
local presetLength = #timeList * 9        -- (<<<, >>>, <<>>, >><<,    v.up, v.down, v.out, v.in,    rnd)
while checkSpace('Preset 0.', presetStart, presetLength, false) == false do              --check if enough space is present
  presetStart = presetStart + 1        --tries new starting point until proper space is foundn
end
presetFinish = presetStart + presetLength - 1



---- Create Progress Bar ----
pBars.main = ProgressBar:new('Assigning Delay Preset Values')
pBars.main:setrange(0, timeCt)


---- Delay Presets: Horizontal Straight and Wings ----
local sleepPeriod = 0
local presetCurrent = presetStart

local directionNames = {'>>', '<<', '<<>>', '>><<', 'Up', 'Down', 'V. Out', 'V. In', 'SHUFFLE'}
local storeOptions = ' /s /o /so=Prog /use=Active /v=false /vt=true /ef=false'

local set = 1

gma.cmd('ClearAll')

for loop = 1, 4 do
    for i = 1, #timeList do
        for group = 1, #rows do
            gma.cmd('Group '..rows[group])
            
            if         loop == 1 then gma.cmd('PresetType '..pTypes_str..' At Delay 0 Thru '..timeList[i])                                                                        --loop 1: left to right
            elseif    loop == 2 then gma.cmd('PresetType '..pTypes_str..' At Delay '..(timeList[i] * chaserWings_mult)..' Thru 0')                                            --loop 2: right to left
            elseif    loop == 3 then gma.cmd('PresetType '..pTypes_str..' At Delay '..(timeList[i] * chaserWings_mult)..' Thru 0 Thru '..(timeList[i] * chaserWings_mult))    --loop 3: center out
            elseif    loop == 4 then gma.cmd('PresetType '..pTypes_str..' At Delay 0 Thru '..(timeList[i] * chaserWings_mult)..' Thru 0')    end                                    --loop 4: outside in
        end
        
        gma.cmd('Store Preset 0.'..presetCurrent..storeOptions)
        gma.cmd('ClearAll')
        gma.cmd('Label Preset 0.'..presetCurrent..' \"'..timeList[i]..'s '..directionNames[loop]..'\"') --Label preset. i.e. "2s <<"
        
    presetCt = presetCt + 1
    pBars.main:set(presetCt)
        presetCurrent = presetCurrent + 1
    end
end



---- Delay Presets: Vertical Straight ----
set = 3
for loop = 1, 2 do
    for time = 1, #divisionTimes[set] do --delay fan times
      for grp = 1, #divisionTimes[set][time] do --row
        
        local grpAct = grp --only comes into play on loop 2
        if loop == 2 then
          grpAct = #divisionTimes[set][time] + 1 - grp end --select fixtures in reverse order
            
        cmd('Group '..rows[grpAct])
          for i = 1, #presetTypes do    --for all PresetTypes included
            gma.cmd('PresetType '..presetTypes[i]..' At Delay '..trunc(divisionTimes[set][time][grp], 0.001))    --round off decimals to avoid automatic scientific notation
          end
        presetCt = presetCt + 1
        pBars.main:set(presetCt)
        gma.sleep(sleepPeriod) --reduce CPU load
      end
      cmd('Store Preset 0.'..presetCurrent..' /s /o /so=Prog /use=Active /v=false /vt=true /ef=false')
      cmd('ClearAll')
      
      cmd('Label Preset 0.'..presetCurrent..' \"'..timeList[time]..'s '..directionNames[loop+((set-1)*2)]..'\"') --Label preset. i.e. "2s <<"
      presetCurrent = presetCurrent + 1
    end
end



---- Delay Presets: Vertical Wings ---- 
set = 4
for loop = 1, 2 do
    for time = 1, #divisionTimes[set] do --delay fan times
      for grp = 1, #divisionTimes[set][time] do --row
        
          local grpAct1; local grpAct2;
          if loop == 1 then
            grpAct1, grpAct2 = grp, #groups + 1 - grp --[2] is opposing fixture in pair to [1]
          elseif loop == 2 then
            grpAct1 = #divisionTimes[set][time] + 1 - grp --center or top-of-center group (list is only half of size of actual rig)
            grpAct2 = #groups + 1 - grpAct1        --center or bottom-of-center fixture
          end --select fixtures in reverse order

          cmd('Group '..rows[grpAct1]..' + '..rows[grpAct2])
          for i = 1, #presetTypes do    --for all PresetTypes included
            gma.cmd('PresetType '..presetTypes[i]..' At Delay '..trunc(divisionTimes[set][time][grp], 0.001))    --round off decimals to avoid automatic scientific notation
          end
          presetCt = presetCt + 1
          pBars.main:set(presetCt)
          gma.sleep(sleepPeriod) --reduce CPU load
      end
      cmd('Store Preset 0.'..presetCurrent..' /s /o /so=Prog /use=Active /v=false /vt=true /ef=false')
      cmd('ClearAll')
      
      cmd('Label Preset 0.'..presetCurrent..' \"'..timeList[time]..'s '..directionNames[loop+((set-1)*2)]..'\"') --Label preset. i.e. "2s <<"
      presetCurrent = presetCurrent + 1
    end
end



---- Delay Presets: Shuffled ----
gma.cmd('ClearAll')
for i, group in ipairs(rows) do            -- grab all fixtures
    gma.cmd('Group '..group)
end
gma.cmd('ShuffleSelection')                -- shuffle selection order

for i, time in ipairs(timeList) do
    gma.cmd('PresetType '..pTypes_str..' At Delay 0 Thru '..time)                            -- assign delay to shuffled selection
    gma.cmd('Store Preset 0.'..presetCurrent..storeOptions)                                    -- store next preset; and DO NOT CLEAR SELECTION FROM PROGRAMMER
    gma.cmd('Label Preset 0.'..presetCurrent..' \"'..timeList[i]..'s RND\"')                 -- Label preset. i.e. "2s <<"
    
    presetCt = presetCt + 1
    pBars.main:set(presetCt)
    presetCurrent = presetCurrent + 1
end

presetFinish = presetCurrent - 1
pBars.main:stop()

gma.cmd('BlindEdit Off')






------------------------------------------------------------------------------------
--------------------------- EXECUTION MACROS ---------------------------------------
------------------------------------------------------------------------------------
local timeVar = varName..'_FANDELAY_TIME'
local dirVar = varName..'_FANDELAY_DIR'

---- Get Starting Macro; Check for Sufficient Space ----
local macroLength = #timeList + 9 + 4
local macStart = advanceSpace('Macro', macStart_target, macroLength, 1, 1)

local macCurrent = tonumber(macStart)


---- Create Timing Macros ----
local timeStart = macCurrent
local timeFinish = (macCurrent + #timeList - 1)

for i = 1, #timeList do
  if timeList[i] == 0 then macStore(macCurrent, 'Sweep OFF')
  else macStore(macCurrent, 'Sweep '..tostring(timeList[i])..'s') end
  
  macLine(macCurrent, 1, 'SetVar $'..timeVar..' = '..tostring(i-1)) --set time variable
  macLine(macCurrent, 2, 'Plugin '..tostring(pluginSlot_execution)) --run executor plugin
  macLine(macCurrent, 3, 'Unlock Macro '..tostring(timeStart)..' Thru '..timeFinish) --(next 4 lines) set color of macros to reflect active macro
  macLine(macCurrent, 4, 'Appearance Macro '..tostring(timeStart)..' Thru '..timeFinish..' /r=15 /g=15 /b=100')
  macLine(macCurrent, 5, 'Appearance Macro '..macCurrent..' /r=100 /g=100 /b=100')
  macLine(macCurrent, 6, 'Lock Macro '..tostring(timeStart)..' Thru '..timeFinish)
  
  macCurrent = macCurrent + 1
end



---- Create Direction Macros
local dirStart = macCurrent
local dirFinish = (macCurrent + #directionNames - 1)

local dirValue = presetStart

for i = 1, #directionNames do
  macStore(macCurrent, directionNames[i])
  macLine(macCurrent, 1, 'SetVar $'..dirVar..' = '..tostring(dirValue)) --set mathematical value for execution plugin to use
  macLine(macCurrent, 2, 'Plugin '..tostring(pluginSlot_execution)) --run executor plugin
  macLine(macCurrent, 3, 'Unlock Macro '..tostring(dirStart)..' Thru '..dirFinish) --(next 4 lines) set color of macros to reflect active macro
  macLine(macCurrent, 4, 'Appearance Macro '..tostring(dirStart)..' Thru '..tostring(dirFinish)..' /r=0 /g=100 /b=0')
  macLine(macCurrent, 5, 'Appearance Macro '..macCurrent..' /r=100 /g=100 /b=100')
  macLine(macCurrent, 6, 'Lock Macro '..tostring(dirStart)..' Thru '..dirFinish)
  
  dirValue = dirValue + #timeList
  macCurrent = macCurrent + 1
end


---- CREATE SYSTEM MACROS ----
macCurrent = macCurrent + 1 --create empty space before system macros
local macFinish = macCurrent + 2 --set finishing macro number for use in lock, unlock, and uninstall macros for created macros

local groupString = 'Group '..rows[1]
if #rows > 1 then
  for i = 2, #rows do
    groupString = groupString..' + '..rows[i]
  end
end

local pluginString = 'Plugin '..pluginSlot_execution..' + '..pluginSlot_updater

--LOCK ALL
macStore(macCurrent, 'LOCK '..varName..' Sweep Macros')
macLine(macCurrent, 1, 'Assign Macro 1.'..macFinish..'.1 Thru /disabled=yes') --disable uninstall macro
macLine(macCurrent, 2, 'Lock Macro '..macStart..' Thru '..macFinish)
macLine(macCurrent, 3, 'Lock Preset 0.'..presetStart..' Thru 0.'..presetFinish)
macLine(macCurrent, 4, 'Lock Plugin '..pluginSlot_execution)


mac_lock = macCurrent
macCurrent = macCurrent + 1

--UNLOCK ALL
macStore(macCurrent, 'UNLOCK '..varName..' Sweep Macros')
macLine(macCurrent, 1, 'Unlock Macro '..macStart..' Thru '..macFinish)
macLine(macCurrent, 2, 'Unlock Preset 0.'..presetStart..' Thru 0.'..presetFinish)
macLine(macCurrent, 3, 'Unlock Plugin '..pluginSlot_execution)
macLine(macCurrent, 4, 'Assign Macro 1.'..macFinish..'.1 Thru /disabled=no') --enable uninstall macro

mac_unlock = macCurrent
macCurrent = macCurrent + 1

--UNINSTALL
macStore(macCurrent, 'UNINSTALL '..varName..' SWEEP MACROS')
macLine(macCurrent, 1, 'Unlock '..groupString) --unlock groups used for alignment purposes
macLine(macCurrent, 2, 'SetVar '..dirVar..' =') --delete alignment variable from commandline variable list
macLine(macCurrent, 3, 'SetVar '..timeVar..' =') --delete time variable
macLine(macCurrent, 4, 'Delete Preset 0.'..tostring(presetStart)..' Thru 0.'..tostring(presetFinish))
macLine(macCurrent, 5, 'Delete '..pluginString)
macLine(macCurrent, 6, 'ReloadPlugins /nc')
macLine(macCurrent, 7, 'Delete Macro '..macStart..' Thru '..macFinish) --delete all generated macros

mac_uninstall = macCurrent




---------------------------------------------------------------------------
-----------------------CREATE EXECUTION PLUGIN-----------------------------
---------------------------------------------------------------------------


local r = {'local target_range = {'}
for i, v in ipairs(userconfig.target_range) do
  r[#r+1] = '    [['..v..']],'
end
r[#r+1] = '}'
local ranges_str = table.concat(r, '\n')
local execScript = [=[
-- Delay Sweeps - Execution Module
-- v1.8.1

-- Created by Jason Giaffo
-- Last updated May 30, 2019
-- Contact: http://giaffodesigns.com/contact/

-- All copies and revisions of this code are copyright property of Giaffo Designs and may not be used, in any part or in entirety, without written consent of Jason Giaffo and credit where used. This plugin is only approved for usage by persons who have directly purchased it from GiaffoDesigns.
-- TL;DR: don't be a dick; don't steal people's work; give credit to people





---- USER CONFIG ----
]=]..ranges_str..[=[



















---- PLUGIN BUILD CONFIG ---
local timeVarSys = ']=]..timeVar..[['
local dirVarSys = ']]..dirVar..[['


local delaySweep_type = ']]..delaySweep_type..[['
local delaySweep_id   = ]]..delaySweep_id..[[ 


-- check existing entries in global array if it exists to not add self more than once
if (not delaySweep_execPlugins) then delaySweep_execPlugins = {} end
local matchStatus = false
for i, v in ipairs(delaySweep_execPlugins) do
    if (v.id == delaySweep_id) and (v.type == delaySweep_type) then
        matchStatus = true
        break
    end
end

--if not already in array, add an entry
if (not matchStatus) then
    local pos = #delaySweep_execPlugins+1
    delaySweep_execPlugins[pos]      = {}
    delaySweep_execPlugins[pos].id   = delaySweep_id
    delaySweep_execPlugins[pos].type = delaySweep_type
end


---- Local Shortcut Variables ----
local cmd = gma.cmd
local text = gma.textinput
local print = gma.echo
local getHandle = gma.show.getobj.handle



---- EXECUTION PLUGIN ----
local function main()
    ---- calculate delay preset to be used ----
    local timeVar = tonumber(gma.show.getvar(timeVarSys))
    local dirVar = tonumber(gma.show.getvar(dirVarSys))
    local delayPreset = dirVar + timeVar


    ---- call function and store to sequences ----
    cmd('BlindEdit On')
    cmd('ClearAll')
    for i, v in ipairs(target_range) do
        cmd('Call Preset 0.'..delayPreset)
        cmd('Store '..v..' /ka=true /m /s /so=Prog /use=Active /nc')
    end
    cmd('ClearAll')
    cmd('BlindEdit Off')

    ::EOF::
end


return main
]]

createPlugin(pluginSlot_execution, 'Execute '..varName..' Sweeps', execScript)




--------------------------------
---- INSTALL UPDATER PLUGIN ----
--------------------------------








local updater_script = [===[
-- Delay Sweeps - Preset Updater
-- v1.8.1

-- Created by Jason Giaffo
-- Last updated May 30, 2019
-- Contact: http://giaffodesigns.com/contact/

-- All copies and revisions of this code are copyright property of Giaffo Designs and may not be used, in any part or in entirety, without written consent of Jason Giaffo and credit where used. This plugin is only approved for usage by persons who have directly purchased it from GiaffoDesigns.
-- TL;DR: don't be a dick; don't steal people's work; give credit to people



--------------------------------------------------------------------------------------------
------------------------------ DO NOT EDIT BELOW THIS POINT --------------------------------
--------------------------------------------------------------------------------------------




-- Values copied from original install. Do not edit. If you want to make changes, do a re-install. --


local chaserWings = ]===]..tostring(chaserWings)..[===[ --values: true, false; do not use quotes
                          --doubles "wavelength" for wings for consistent distance between unidirectional and bidirectional sweeps across rig;

--Preset Type Information
local presetTypes   = {]===]..table.concat(userconfig.presetTypes, ', ')..[===[}     --to apply to multiple types, enter multiple numbers between {} brackets, separated by a comma; enter 0 for all preset types to be included

local presetStart  = ]===]..presetStart..[===[;
local presetFinish = ]===]..presetFinish..[===[;



local delaytime_list = {]===]..table.concat(delaytime_list, ', ')..[===[};












--SHORTCUT VARIABLES--
local cmd = gma.cmd
local text = gma.textinput
local print = gma.echo
local getHandle = gma.show.getobj.handle
local unpack = table.unpack

---- LOCAL FUNCTIONS ----
function getClass(str)
  return gma.show.getobj.class(getHandle(str))
end

function trunc(num, mod)
  local x = num - (num%mod)
  return x
end

function macStore(macroNum, label)
  gma.cmd('Store Macro 1.'..macroNum) --create macro
  gma.cmd('Label Macro 1.'..macroNum..' \"'..label..'\"') --label the macro
end



function macLine (macroNum, lineNum, command, wait)
  cmd('Store Macro 1.'..macroNum..'.'..lineNum)
  cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/cmd = \"'..command..'\"')
  if wait then cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/wait = \"'..wait..'\"') end
end



function textCheck(barText, dialogueText, loop, numberonly)
  local dialogueList = {dialogueText, 'invalid input: please enter numbers only'}
  local x = 1
  
  local t
  local validStatus = false
  while validStatus == false do
    t = gma.textinput(barText, dialogueList[x])
    if t == nil then break                       --functions for empty input
    elseif t == dialogueList[x] then
      if loop ~= true then --false will make an empty input signal end of function
        t = nil             --true will skip this if statement so the function can loop
        break
      end
    end
      
    if numberonly == true then --in case only number input is wanted but a normal string has been entered
      if tonumber(t) ~= nil then
        validStatus = true
      else
        x = 2
      end
    else validStatus = true
    end
  end
  return t
end



function checkSpace(poolType, start, length) --checks if range of pool spaces is empty
  local finish = start + length - 1 --set our finishing point
  local emptyStatus = true
  for i = start, finish do
    if getClass(poolType..' '..tostring(i)) then --if space is not empty
      emptyStatus = false
      break
    end
  end
  return emptyStatus
end



local function advanceSpace(poolType, start, length, pad_before, pad_after)
    --new version, has checkSpace() function embedded, padding added
    --padding parameters are optional; default to 0 if not provided
    
    local function checkSpace(poolType, start, length) --checks if range of pool spaces is empty
      local finish = start + length - 1 --set our finishing point
      local emptyStatus = true
      for i = start, finish do
        if getClass(poolType..' '..tostring(i)) then --if space is not empty
          emptyStatus = false
          break
        end
      end
      return emptyStatus
    end

    local pad_before    = pad_before    or 0                            --set for 0 if not provided
    local pad_after        = pad_after        or 0                            --set for 0 if not provided
    pad_before, pad_after = math.abs(pad_before), math.abs(pad_after)
    local length_actual = length + pad_before + pad_after                --length that will be used in space check
    
    local finalStart = start
    while checkSpace(poolType, finalStart, length_actual) == false do
        finalStart = finalStart + 1
    end
  
    finalStart = finalStart + pad_before                                --offset returned answer for pre-padding
    return finalStart
end



function getGroup(grpNum)
  gma.cmd('SelectDrive 1') --select the internal drive
  
  local file = {}
  file.name = 'tempfile_getgroup.xml' 
  file.directory = gma.show.getvar('PATH')..'/'..'importexport'..'/'
  file.fullpath = file.directory..file.name
  
  gma.cmd('Export Group ' .. grpNum .. ' \"' .. file.name .. '\"') -- create temporary file
  
  local t = {}  --convert XML file into a table
  for line in io.lines(file.fullpath) do
    t[#t + 1] = line
  end
  os.remove(file.fullpath) --delete temporary file
  
  local groupList = {} --declare groupList
  for i = 1, #t do
    if t[i]:find('Subfixture ') then
      local indices = {t[i]:find('\"%d+\"')} --find points of quotation marks
      indices[1], indices[2] = indices[1] + 1, indices [2] - 1 --move reference points to first an last characters inside those marks
      
      --label based on status as a fixture or as a channel
      local fixture
      if t[i]:find('fix_id') then
        fixture = 'Fixture ' .. tostring(t[i]:sub(indices[1], indices[2])) --extract the number as the fixture number
      elseif t[i]:find('cha_id') then
        fixture = 'Channel ' .. tostring(t[i]:sub(indices[1], indices[2])) end --extract the number as the fixture number
        
      --if the object contains a subfixture...
      if t[i]:find('sub_index') then
        local indices = {t[i]:find('\"%d+\"', indices[2]+2)}
        indices[1], indices[2] = indices[1] + 1, indices[2] - 1
        fixture = fixture .. '.' .. tostring(t[i]:sub(unpack(indices)))
      end
      
      --append to list
      groupList[#groupList + 1] = fixture --extract the number to the group list
    end
  end
  
  return groupList
end

function createPlugin(num, name, script, EOL)

  -- establish if plugin will Execute On Load --
  local EOLnum
  if EOL then EOLnum = 1 
  else EOLnum = 0 end
  
  -- Establish filepath --
  cmd('SelectDrive 1') --select internal drive as default access path
  
  local plugin = {}
  plugin.name = 'tempfile_createplugin'
  plugin.directory = gma.show.getvar('PLUGINPATH')..'/'
  plugin.fullpathLUA = plugin.directory..plugin.name..'.lua'
  plugin.fullpathXML = plugin.directory..plugin.name..'.xml'


  -- Create text for plugin XML file --
  local xmlText = [[
<?xml version="1.0" encoding="utf-8"?>
<MA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.malighting.de/grandma2/xml/MA" xsi:schemaLocation="http://schemas.malighting.de/grandma2/xml/MA http://schemas.malighting.de/grandma2/xml/3.2.2/MA.xsd" major_vers="3" minor_vers="2" stream_vers="2">
    <Info datetime="2016-09-26T20:40:54" showfile="dummyfile" />
    <Plugin index="1" execute_on_load="]]..EOLnum..[[" name="]]..name..[[" luafile="]]..plugin.name..[[.lua" />
</MA>]]

  -- Write XML file to disk --
  local fileXML = assert(io.open(plugin.fullpathXML, 'w'))
  fileXML:write(xmlText)
  fileXML:close()
  
  -- Write LUA file to disk --
  local fileLUA = assert(io.open(plugin.fullpathLUA, 'w'))
  fileLUA:write(script)
  fileLUA:close()


  -- import plugin --
  cmd('Import \"'..plugin.name..'.xml'..'\" Plugin '..tostring(num)) --load new plugin into showfile

  -- delete temp files --
  os.remove(plugin.fullpathXML)
  os.remove(plugin.fullpathLUA)
end



local function confirm(title, message_box, message_text)
  -- v. 1.0
  -- function avoids using confirmation box function with version 3.1.2.5, which crashes the software
  local confirm_method
  
  local version = gma.show.getvar('version')
  
  if version:find('3.1.2') == 1 then 
    confirm_method = 'textinput'
  else 
    confirm_method = 'box' end
  
  if confirm_method == 'box' then
    return gma.gui.confirm(title, message_box)
  elseif confirm_method == 'textinput' then
    local t = gma.textinput(title, message_text)
    if t then t = true end
    return t
  end
end



local function msgbox(title, message_box, message_text)
  -- v. 1.0
  -- function avoids using confirmation box function with version 3.1.2.5, where it doesn't exist
  local confirm_method
  
  local version = gma.show.getvar('version')
  
  if version:find('3.1.2') == 1 then 
    confirm_method = 'textinput'
  else 
    confirm_method = 'box' end
  
  if confirm_method == 'box' then
    gma.gui.msgbox(title, message_box)
  elseif confirm_method == 'textinput' then
    gma.textinput(title, message_text)
  end
end




---- CLASSES ----
local ProgressBar = {
  value = 0,

  new = function(self, name)
      o = {handle = gma.gui.progress.start(name)}

      setmetatable(o, self)
      self.__index = self
      return o
  end,
  
  set = function(self, num, add)
      if add then num = self.value + num end
      
      num = math.floor(num)
      gma.gui.progress.set(self.handle, num)
      self.value = num
  end,
  
  setrange = function(self, bottom, top)
      if not bottom or not top then return nil end
      gma.gui.progress.setrange(self.handle, bottom, top)
      self.range = {top = top, bottom = bottom}
  end,
  
  settext = function(self, text)
      gma.gui.progress.settext(self.handle, text)
  end,
  
  rename = function(self, name)
      gma.gui.progress.stop(self.handle)
      self.handle = gma.gui.progress.start(name)
      if self.range then gma.gui.progress.setrange(self.handle, self.range.bottom, self.range.top) end
  end,
  
  stop = function(self)
      gma.gui.progress.stop(self.handle)
  end,
  
  time_move = function(self, target, time, add, ignore_top)
      if add then target = self.value + target end
      local start = self.value
      local finish = math.floor(target)
      
      local sleepPeriod
      if math.abs(time) ~= time then sleepPeriod = (1 / time)                                            --allow for negative time values to trigger a "rate" function
      else sleepPeriod = time / (math.abs(finish - start)) end
      
      if not ignore_top and self.range and finish > self.range.top then finish = self.range.top end    --set finish point to top of progress-bar range unless specified to ignore
      
      local dir = 1
      if start > finish then dir = -1 end
      
      for i = start, finish, dir do
          self:set(i)
          gma.sleep(sleepPeriod)
      end    
  end
}





local ST = {
  append = function(self, v)
      self[#self + 1] = v
  end,

  concat = function(self, sep, i, j)
      return table.concat(self, sep, i, j)
  end,
  
  new = function(self, o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      return o
  end,

  shuffle = function(list)
      local iterations = #list
      for x = 1, 4 do                                --repeat process, else last number ends up the same
          for i = iterations, 1, -1 do
              j = math.random(i)
              list[i], list[j] = list[j], list[i]
          end
      end
  end
}














































---- MAIN FUNCTION ----

local pBars = {}

local function main()

local continue = confirm('Update Delay Presets?', "Are you sure you want to update delay time presets?\n\nPress [OK] to continue.", 'Press ENTER to continue.')
if (not continue) then goto EOF end



--OBTAIN ROW POSITIONS
local endMessage = '[HIT ENTER W/O INPUT WHEN DONE]'
local rows = {}
local x = 1 --will determine which displayMessage to use if more than one
local loopct = 1

while true do  
  local displayMessage
  if loopct == 1 then displayMessage = {'DS Group #'}
  else displayMessage = {'Row '..loopct..' Group #'} end
  
  local t = text(displayMessage[x], endMessage)
  if tonumber(t) then
    rows[loopct] = tonumber(t)
    loopct = loopct + 1
  elseif t == nil then
    goto EOF
  elseif t == endMessage then
    break
  end
end

--Generate Group Arrays--
local groups = {}       --groups[group][fixture]
for i = 1, #rows do
  groups[i] = getGroup(rows[i]) --push each group into individual fixtures in group array
end



------------------------------------------------------------------------------------
---------------------------- GENERATE DIVISION ARRAYS ------------------------------
------------------------------------------------------------------------------------
local chaserWings_mult = 1
if chaserWings then chaserWings_mult = 0.5 end



local divisions = {} --format: divisions[direction][group][fixture proportion (on 1 and 2 only)]
for i = 1, 4 do
  divisions[i] = {} --declare nested lists for each direction array
end



---- Generate Division Arrays: Vertical Straight (divisions[3]) ----
if (#groups > 1) then
  local divCt = #groups - 1
  local interval = 1 / divCt
  local proportion = 0
  for grp = 1, #groups do
    divisions[3][grp] = proportion
    proportion = proportion + interval
  end
else
  divisions[3][1] = 0
end

---- Generate Division Arrays: Vertical Wings (divisions[4]) ----
--- LIST IS HALF LENGTH OF GROUP - ACCOUNTED FOR IN PRESET CREATION PORTION OF SCRIPT ---
if (#groups > 2) then
  local divCt = math.ceil(#groups/2) - 1
  local interval = chaserWings_mult / divCt
  local proportion = chaserWings_mult --working backwards so the default direction of this array will be center-out

  for grp = 1, (divCt + 1) do
    divisions[4][grp] = proportion
    proportion = proportion - interval
  end
  
else --in case groups are less than 3 objects long, make delay times 0 (no possible way to fan in or out without at least 3 rows)
  for i = 1, #groups do
    divisions[4][i] = 0
  end
end




------------------------------------------------------------------------------------
-------------------------------- DELAY TIMES ---------------------------------------
------------------------------------------------------------------------------------

--GENERATE AND POPULATE LIST OF DELAY TIMES

local timeList = delaytime_list


------------------------------------------------------------------------------------

local timeCt = 0
---- Time Arrays ----
local divisionTimes = {} --format: divisionTimes[direction][time][group][fixture]; only used for vertical presets now
--divisionTimes[1] and [2]


---- Vertical Time Arrays ----
for dir = 3, 4 do
    divisionTimes[dir] = {} --declare array
    for time = 1, #timeList do
      divisionTimes[dir][time] = {} --declare array
      for grp = 1, #divisions[dir] do
        divisionTimes[dir][time][grp] = timeList[time] * divisions[dir][grp] --time * (group proportion value)
        timeCt = timeCt + 1
      end
    end
end

timeCt = timeCt*2 + (#timeList * 5)                                           -- not entirely sure why it's written like this but not going to mess with it right now
--timeCt = (#timeList * #rows * 4)  + (#timeList * 4)


------------------------------------------------------------------------------------
------------------------- CONVERT TIMES TO PRESETS ---------------------------------
------------------------------------------------------------------------------------

gma.cmd('BlindEdit On')

---- PRESET MANAGEMENT
local presetRange = 'Preset 0.'..presetStart..' Thru 0.'..presetFinish
gma.cmd('Unlock '..presetRange)
local presetCurrent = presetStart
local presetCt = 0
local presetLength = #timeList * 9        -- (<<<, >>>, <<>>, >><<,    v.up, v.down, v.out, v.in,    rnd)


local pTypes_str = table.concat(presetTypes, ' + ')



---- Create Progress Bar ----
pBars.main = ProgressBar:new('Assigning Delay Preset Values')
pBars.main:setrange(0, timeCt)


---- Delay Presets: Horizontal Straight and Wings ----
local sleepPeriod = 0
local presetCurrent = presetStart

local directionNames = {'>>', '<<', '<<>>', '>><<', 'Up', 'Down', 'V. Out', 'V. In', 'SHUFFLE'}
local storeOptions = ' /s /o /so=Prog /use=Active /v=false /vt=true /ef=false'

local set = 1

gma.cmd('ClearAll')

for loop = 1, 4 do
    for i = 1, #timeList do
        for group = 1, #rows do
            gma.cmd('Group '..rows[group])
            
            if         loop == 1 then gma.cmd('PresetType '..pTypes_str..' At Delay 0 Thru '..timeList[i])                                                                        --loop 1: left to right
            elseif    loop == 2 then gma.cmd('PresetType '..pTypes_str..' At Delay '..(timeList[i] * chaserWings_mult)..' Thru 0')                                            --loop 2: right to left
            elseif    loop == 3 then gma.cmd('PresetType '..pTypes_str..' At Delay '..(timeList[i] * chaserWings_mult)..' Thru 0 Thru '..(timeList[i] * chaserWings_mult))    --loop 3: center out
            elseif    loop == 4 then gma.cmd('PresetType '..pTypes_str..' At Delay 0 Thru '..(timeList[i] * chaserWings_mult)..' Thru 0')    end                                    --loop 4: outside in
        end
        
        gma.cmd('Store Preset 0.'..presetCurrent..storeOptions)
        gma.cmd('ClearAll')
        gma.cmd('Label Preset 0.'..presetCurrent..' \"'..timeList[i]..'s '..directionNames[loop]..'\"') --Label preset. i.e. "2s <<"
        
    presetCt = presetCt + 1
    pBars.main:set(presetCt)
        presetCurrent = presetCurrent + 1
    end
end



---- Delay Presets: Vertical Straight ----
set = 3
for loop = 1, 2 do
    for time = 1, #divisionTimes[set] do --delay fan times
      for grp = 1, #divisionTimes[set][time] do --row
        
        local grpAct = grp --only comes into play on loop 2
        if loop == 2 then
          grpAct = #divisionTimes[set][time] + 1 - grp end --select fixtures in reverse order
            
        cmd('Group '..rows[grpAct])
          for i = 1, #presetTypes do    --for all PresetTypes included
            gma.cmd('PresetType '..presetTypes[i]..' At Delay '..trunc(divisionTimes[set][time][grp], 0.001))    --round off decimals to avoid automatic scientific notation
          end
        presetCt = presetCt + 1
        pBars.main:set(presetCt)
        gma.sleep(sleepPeriod) --reduce CPU load
      end
      cmd('Store Preset 0.'..presetCurrent..' /s /o /so=Prog /use=Active /v=false /vt=true /ef=false')
      cmd('ClearAll')
      
      cmd('Label Preset 0.'..presetCurrent..' \"'..timeList[time]..'s '..directionNames[loop+((set-1)*2)]..'\"') --Label preset. i.e. "2s <<"
      presetCurrent = presetCurrent + 1
    end
end



---- Delay Presets: Vertical Wings ---- 
set = 4
for loop = 1, 2 do
    for time = 1, #divisionTimes[set] do --delay fan times
      for grp = 1, #divisionTimes[set][time] do --row
        
          local grpAct1; local grpAct2;
          if loop == 1 then
            grpAct1, grpAct2 = grp, #groups + 1 - grp --[2] is opposing fixture in pair to [1]
          elseif loop == 2 then
            grpAct1 = #divisionTimes[set][time] + 1 - grp --center or top-of-center group (list is only half of size of actual rig)
            grpAct2 = #groups + 1 - grpAct1        --center or bottom-of-center fixture
          end --select fixtures in reverse order

          cmd('Group '..rows[grpAct1]..' + '..rows[grpAct2])
          for i = 1, #presetTypes do    --for all PresetTypes included
            gma.cmd('PresetType '..presetTypes[i]..' At Delay '..trunc(divisionTimes[set][time][grp], 0.001))    --round off decimals to avoid automatic scientific notation
          end
          presetCt = presetCt + 1
          pBars.main:set(presetCt)
          gma.sleep(sleepPeriod) --reduce CPU load
      end
      cmd('Store Preset 0.'..presetCurrent..' /s /o /so=Prog /use=Active /v=false /vt=true /ef=false')
      cmd('ClearAll')
      
      cmd('Label Preset 0.'..presetCurrent..' \"'..timeList[time]..'s '..directionNames[loop+((set-1)*2)]..'\"') --Label preset. i.e. "2s <<"
      presetCurrent = presetCurrent + 1
    end
end



---- Delay Presets: Shuffled ----
gma.cmd('ClearAll')
for i, group in ipairs(rows) do            -- grab all fixtures
    gma.cmd('Group '..group)
end
gma.cmd('ShuffleSelection')                -- shuffle selection order

for i, time in ipairs(timeList) do
    gma.cmd('PresetType '..pTypes_str..' At Delay 0 Thru '..time)                            -- assign delay to shuffled selection
    gma.cmd('Store Preset 0.'..presetCurrent..storeOptions)                                    -- store next preset; and DO NOT CLEAR SELECTION FROM PROGRAMMER
    gma.cmd('Label Preset 0.'..presetCurrent..' \"'..timeList[i]..'s RND\"')                 -- Label preset. i.e. "2s <<"
    
    presetCt = presetCt + 1
    pBars.main:set(presetCt)
    presetCurrent = presetCurrent + 1
end

pBars.main:stop()

gma.cmd('BlindEdit Off')


-- PRESET MANAGEMENT
gma.cmd('Lock '..presetRange)

-- final confirmation
msgbox('Update Completed', presetRange..' updated.', presetRange..' updated.')
    

::EOF::
end



---- CLEANUP FUNCTION ----
local function cleanup()
    for k, v in pairs(pBars) do
        v:stop()
    end
end




return main, cleanup
]===]


createPlugin(pluginSlot_updater, 'Update '..varName..' Sweeps', updater_script)





-----------------------------------------------------
---- COLOR CODE AND LOCK FROM ACCIDENTAL EDITING ----
-----------------------------------------------------

cmd('Appearance Macro '..(macFinish - 2)..' Thru '..macFinish..' /r=100 /g=100 /b=100') --color lock/uninstall macros white
cmd('Appearance Macro '..dirStart..' Thru '..dirFinish..' /r=0 /g=100 /b=0')            --color align direction macros green
cmd('Appearance Macro '..timeStart..' Thru '..timeFinish..' /r=0 /g=0 /b=100')          --color time set macros blue
cmd('Macro '..mac_lock)                                                                    --run Lock macro


-- Confirm completion of installation
local msg_confirm = [[
Installation of "Delay Sweep Macros" Complete

First generated Macro: #]]..macStart

msgbox('Installation Complete', msg_confirm, 'First Macro stored at #'..macStart)       -- print to a message box
gma.echo(msg_confirm)                                                                   -- print to System Monitor



::EOF::
end --END OF PLUGIN


local function cleanup()
  for k, v in pairs(pBars) do
    v:stop()
  end
end


return main, cleanup