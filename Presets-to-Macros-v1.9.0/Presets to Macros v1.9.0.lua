--[[
Presets to Macros v1.9.0
Created by Jason Giaffo
Contact: http://GiaffoDesigns.com/contact/
Last updated Jul 20, 2019

Takes presets and groups and turns them into macros you can use in a layout.

v1.7 updates:
-plugin now references generated executors, rather than calling sequences directly
-lock and unlock macros added to Uninstall macro to avoid accidental uninstallation

v1.8 updates:
-bug fix: no longer overwrites existing executors, easier for multiple installations
-bug fix: no longer freezes using un-named groups or presets

v1.9 updates:
-new: custom presetTypes now supported (but may only be referenced by number)
-new: completion message at end of plugin installation
--]]


--USER CONFIG
local macStart = 1001        --starting macro pool item to be stored to
local seqStart = 1001        --starting sequence number to be stored to
local execStart = '500.101'     --leave quotes around executor number; starting executor position

local line2_hold = true     --possible values: true, false. Do not use quotes. 
                               --If true, "line 2" will show infinitely;
                               --If false, "line 2" will only hold for 2 seconds







--local shortcut variables
local text = gma.textinput
local cmd = gma.cmd
local getHandle = gma.show.getobj.handle


--FUNCTIONS
function getLabel(str)
  return gma.show.getobj.label(getHandle(str))
end


function getClass(str)
  return gma.show.getobj.class(getHandle(str))
end



local function getPTypeName(num)
    -- input: str:name OR num:num
    -- output; tbl .name .num

    local obj = string.format('PresetType %d', num)

    return gma.show.property.get(gma.show.getobj.handle(obj), 'ScreenName')
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



function checkSpace(poolType, start, length, displayMessage) --checks if range of pool spaces is empty
  local finish = start + length - 1 --set our finishing point
  local errorMessage = poolType..' space conflict: please run plugin with a new '..poolType..' start slot'
  local emptyStatus = true
  for i = start, finish do
    if getClass(poolType..' '..tostring(i)) ~= nil then --if space is not empty
      emptyStatus = false
      if displayMessage == true then --return error message if this condition has been set
        gma.feedback(errorMessage)
        gma.echo(errorMessage)
      end
      break
    end
  end
  return emptyStatus
end


function advanceSpace(poolType, start, length)
  finalStart = start
  while checkSpace(poolType, finalStart, length) == false do
    finalStart = finalStart + 1
  end
  
  return finalStart
end


local function advanceExec(page, exec, ct, minExec)
  --check each spot from start until end
  --if there is a collision, function starts over at next available executor on page
  --if the executor number hits 100, 199, or 210, and there still are more to go, then
  --the count restarts on the next page at the minimum executor number.
  --if there is not enough space to pull this off on any page, the function returns nil and an error message
    local function getExecutorStatus(page, executor)  
      local slotStatus = gma.show.getobj.handle('Executor '..page..'.'..executor); --determine if slot is empty
                
      if slotStatus then                                --return value based on executor handle
        if getHandle('Executor '..page..'.'..executor..' Cue') then
            local c = getClass('Executor '..page..'.'..executor..' Cue');
            if c == "CMD_SEQUENCE" then
              return 'OFF' --response for non-active executor
            elseif c == "CMD_CUE" then
              return 'ON' --response for active executor
            end
        else
            return 'NON-SEQ' --response for non-sequence executors
        end
      else
        return 'EMPTY' --response for empty executor slots
      end
    end
    
  local function checkPass(exec, ct)
    local limits = {100, 199, 210}
    local status_pass = true
    for i = 1, #limits do
      if exec <= limits[i] and (exec+ct-1) > limits[i] then 
        status_pass = false 
        break
      end      
    end
    
    return status_pass
  end
  
  local function checkNum(num)
    local limits = {100, 199, 210}
    local status_pass = true
    for i = 1, #limits do
      if num == limits[i] then status_pass = false; break; end;
    end
    
    return status_pass
  end

  local error_msg = 'Error: minExec set too high'
  
  if not minExec then minExec = 1 end
  if not ct then ct = 1 end
  
  local addPage = true
  if not checkPass(minExec, ct) then addPage = false end
  
  local pageCurrent = page
  local execCurrent = exec
  local pass = false

  while pass == false do
    if checkPass(execCurrent, ct) then
        for i = 1, ct do
          if getExecutorStatus(pageCurrent, execCurrent+i-1) == 'EMPTY' then
            if i == ct then pass = true end
          else
            if checkNum(execCurrent+i) then
                execCurrent = execCurrent + i
                break
            else
                if addPage then
                    pageCurrent = pageCurrent + 1
                    execCurrent = minExec
                    break
                else
                    return nil, error_msg
                end
            end
          end
        end
    else
        if addPage then
            pageCurrent = pageCurrent + 1
            execCurrent = minExec
        else
            return nil, error_msg
        end
    end
  end
  
  return pageCurrent, execCurrent
end



function macStore(macroNum, label) --generate macro
  gma.cmd('Store Macro 1.'..macroNum) --create macro
  gma.cmd('Label Macro 1.'..macroNum..' \"'..label..'\"') --label the macro
end



function macLine (macroNum, lineNum, command, wait) --generate new line within macro
  cmd('Store Macro 1.'..macroNum..'.'..lineNum)
  cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/cmd = \"'..command..'\"')
  if wait then cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/wait = \"'..wait..'\"') end
end


function match(a, b)            --checks to see if a and b match or (if strings) if one contains the other, ignoring capitalization
  if a == b then return true    --used for user input of preset type by text rather than number
  elseif type(a) == 'string' and type(b) == 'string' then
    if string.find(string.lower(a), string.lower(b)) ~= nil or
       string.find(string.lower(b), string.lower(a)) ~= nil then
      return true
    else return false
    end
  else return false;
  end
end


function table.find(t, target, i, j) --traverses table (t) to find the target using the match function defined above
  if i == nil then i = 1 end --set default values if optional variables not entered
  if j == nil then j = #t end
  for n = i, j do
    if match(t[n], target) == true then
      return n;
    end
  end
  return nil
end


return function()
-----------------------------------------------------------------
--------------------- START OF PLUGIN ---------------------------
-----------------------------------------------------------------
--COLOR/PRESET SELECTION--
-- local presetTypes = {'Dimmer', 'Position', 'Gobo', 'Color', 'Beam', 'Focus', 'Control', 'Shapers', 'Video'};
-- presetTypes[0] = 'All'

local displayMessage = {'Color (4), Position (2), etc.', 'please use number or name of preset type'}
local x = 1 --will determine which display message is used during plugin usage

local pType --declare local variable so assignment in loop is not lost
local pTypeNum

while true do --insert function as a loop in case of invalid inputs
    local presetInput = text('Preset Type', displayMessage[x])  --USER INPUT FOR PRESET TYPE
  
    if (tonumber(presetInput) ~= nil) then  --matches based on number input
        -- pType = presetTypes[tonumber(presetInput)] 
        pType = getPTypeName(tonumber(presetInput))
        pTypeNum = presetInput
    elseif string.find(presetInput, '%a') == 1 then  --matches based on first three letters of text input
        local inputAbbr = string.match(presetInput, '%a%a%a')
        pTypeNum = tostring(table.find(presetTypes, inputAbbr, 0))
        pType = presetTypes[tonumber(pTypeNum)]
    end
    
    if pType and pTypeNum then break --ends loop if values have been assigned
    else x = 2 end --changes text displayed if loop is performed
end

--POPULATE PRESET LIST--
local pNum = {} --list where numbers of preset pool items will be stored
local pName = {} --list where names of preset pool items will be stored

local displayMessage = {'HIT ENTER WHEN DONE', 'ONLY NUMERICAL INPUT SUPPORTED'}
local loopct = 1
local x = 1
local emptyGroup, emptyColor = false, false

while true do
  local t = text(pType..' #'..loopct, displayMessage[x])
  if t == displayMessage[x] then
    break  --will terminate loop if ENTER is hit without a new value
  elseif tonumber(t) then 
    pNum[loopct] = t
    pName[loopct] = getLabel('Preset '..pTypeNum..'.'..t)
    if (not pName[loopct]) then pName[loopct] = pType..' '..t end
    loopct = loopct + 1
    x = 1 --resets the display message to the original line
  elseif (not t) then--allows X button to end plugin rather than continue loop
    goto EOF
  else    --restarts loop with error message displayed instead
    x = 2
  end
end


--POPULATE GROUP LIST--
local grpNum = {} --list where numbers of group pool items will be stored
local grpName = {} --list where names of group pool items will be stored

local loopct = 1
local x = 1

while true do
  local t = text('Group #'..loopct, displayMessage[x])
  if t == displayMessage[x] then
    break  --will terminate loop if ENTER is hit without a new value
  elseif tonumber(t) ~= nil then 
    grpNum[loopct] = t
    grpName[loopct] = getLabel('Group '..t)
    if not grpName[loopct] then grpName[loopct] = 'Group '..t end
    loopct = loopct + 1
    x = 1 --resets the display message to the original line
  elseif t == nil then --allows X button to end plugin rather than continue loop
    goto EOF
  else    --restarts loop with error message displayed instead
    x = 2
  end
end


gma.echo('List creation completed:')
gma.echo('Groups: '..tostring(#grpNum))
gma.echo(pType..'s: '..tostring(#pNum))

--STORAGE STARTING POINTS
local seqLength = #grpNum
seqStart = tonumber(seqStart) --in case somebody adds quotes to the user config number
seqStart = advanceSpace('Sequence', seqStart, seqLength)

local macroLength = (#grpNum + 1) * #pNum + 1 --accounts for length of sequence, appearance, and uninstall macros
macStart = tonumber(macStart) --in case somebody adds quotes to the user config number
macStart = advanceSpace('Macro', macStart, macroLength)

---- Convert Starting Exec field into page and executor
local startingFader, startingPg

local indices = {execStart:find('[%.]')}
startingPg         = tonumber(execStart:sub(1, (indices[1] - 1)))                --extract everything before the decimal
startingFader     = tonumber(execStart:sub((indices[1] + 1), indices[-1]))    --extract everything after the decimal

local minExec
if startingFader < 100 then minExec = 1
else minExec = 101 end

startingPg, startingFader = advanceExec(startingPg, startingFader, seqLength, minExec)    --acoid collisions with any existing executors
cmd('Store Page '..startingPg)                                                            --make sure page for these executors exists to avoid command line errors

--PRESETS TO SEQUENCE CUES BY GROUP AND CREATE MACROS--
local macCurrent = macStart
local seqCurrent = seqStart
local faderCurrent = startingFader

cmd('ClearAll')

local str_storeOpt = ' /use=active /so=Prog /nc'

local waitValue = 2
if line2_hold then waitValue = 'go' end
for i = 1, #grpNum do
  local macGroup = {} --this will hold the numbers of the first and last macros referencing the same group for use in line 2 of the macro
  macGroup.start = macStart + (#pNum * (i-1))
  macGroup.final = macStart + (#pNum * i) - 1
  
  local execCurrent = tostring(startingPg..'.'..faderCurrent)
  
  for j = 1, #pNum do
    cmd('Group '..grpNum[i]..' At Preset '..pTypeNum..'.'..pNum[j]) --group at preset
    cmd('Store Sequence '..seqCurrent..' Cue '..j..str_storeOpt) --store to sequence and cue

    if j == 1 then
      cmd('Assign Sequence '..seqCurrent..' At Executor '..execCurrent) --assign sequence to executor
    end    

    cmd('Label Sequence '..seqCurrent..' \"'..grpName[i]..' '..pType..'\"'); --label sequence
    cmd('Label Sequence '..seqCurrent..' Cue '..j..' \"'..grpName[i]..' '..pName[j]..'\"');  --label cue w/ name tables

    macStore(macCurrent, grpName[i]..' '..pName[j]) --create macro; label with group and preset names
    macLine(macCurrent, 1, 'Goto Executor '..execCurrent..' Cue '..j)
    macLine(macCurrent, 2, 'Off Macro '..macGroup.start..' Thru '..macGroup.final..' - '..macCurrent, waitValue)
    macLine(macCurrent, 3, '')
    
    cmd('ClearAll'); --clear your programmer
    
    macCurrent = macCurrent + 1 --move to next macro number
    gma.sleep(0.05) --to ease processing power conflicts
  end  
  seqCurrent     = seqCurrent + 1 --move to next sequence number
  faderCurrent    = faderCurrent + 1
end

local seqEnd = seqCurrent - 1 --save value for final sequence used
local execFinal = tostring(startingPg..'.'..(faderCurrent - 1))

--COLUMN APPEARANCE MACROS--
local macCurrent = macStart + (#grpNum * #pNum) --resets variable at the position after all color macros based on the number of possible combinations
local macAppStart = macCurrent --save value for starting appearance macro number

for i = 1, #pNum do --iterate for number of colors/presets
  cmd('Store Macro '..macCurrent) --create macro
  cmd('Store Macro 1.'..macCurrent..'.1') --create macro line 1
  cmd('Label Macro '..macCurrent..' \"Appearance '..pName[i]..'\"') --label macro "Appearance (color name)"
  local t = 'Macro '..(macStart+i-1) --text which will be saved in appearance macro
  
  if #grpNum > 1 then --
    local index = i - 1
    for j = 1, (#grpNum-1) do
      index = index + #pNum --number of next macro referencing same color
      t = t..' + '..(macStart + index) --appends the number to the macro line for setting appearance
    end
  end
    
  cmd('Assign Macro 1.'..macCurrent..'.1 /cmd = \"Appearance '..t..'\"') --assign text to macro line
  macCurrent = macCurrent + 1;
end

local macAppEnd = macCurrent - 1 --create reference value for final appearance macro
cmd('Appearance Macro '..macAppStart..' thru '..macAppEnd..' /r=100 /g=100 /b=100') --set all appearance macros to white

local mac_sys_start = macCurrent
local mac_uninstall = mac_sys_start + 2

--lock uninstall macro
macStore(macCurrent, 'DISABLE Uninstall Macro')
macLine(macCurrent, 1, 'Assign Macro 1.'..mac_uninstall..'.* /disabled=yes')
macLine(macCurrent, 2, 'Lock Macro '..mac_uninstall)
macCurrent = macCurrent + 1


--enable uninstall macro
macStore(macCurrent, 'ENABLE Uninstall Macro')
macLine(macCurrent, 1, 'Unlock Macro '..mac_uninstall)
macLine(macCurrent, 2, 'Assign Macro 1.'..mac_uninstall..'.* /disabled=no')
macCurrent = macCurrent + 1


--UNINSTALL MACRO--
macStore(macCurrent, 'UNINSTALL COLOR MACROS')
macLine(macCurrent, 1, 'Delete Sequence '..seqStart..' Thru '..seqEnd..' /nc')
macLine(macCurrent, 2, 'Delete Macro '..macStart..' Thru '..macCurrent)

cmd('Macro '..mac_sys_start) --run uninstall-lock macro


---- COMPLETION MESSAGE ----
local msg_tbl = {
    'Plugin has finished successfully',
    '',
    string.format('PresetType Used: #%d, "%s"', pTypeNum, pType), 
    string.format('First installed macro: %d', macStart)
}
local msg = table.concat(msg_tbl, '\n')
gma.gui.msgbox('PLUGIN COMPLETE', msg)

::EOF::
end  --END OF PLUGIN
