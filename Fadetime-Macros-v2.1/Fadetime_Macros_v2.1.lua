--[[
Sequence Fade-Time Macros v2.1 - Installer
Created by Jason Giaffo
Contact: http://GiaffoDesigns.com/contact/
Last updated November 30, 2016


Creates macros to set selected sequences' cues to a given fade time.
Also creates a macro with the set sequences saved so that the range 
can be adjusted later as needed without completely redoing the whole list.
--]]

local cmd = gma.cmd
local text = gma.textinput
local print = gma.echo
local getHandle = gma.show.getobj.handle
local getClass = function(str)
  return gma.show.getobj.class(getHandle(str))
end
local unpack = table.unpack

local getLabel = function(str)
  local t = gma.show.getobj.label(getHandle(str))
  if t then return t
  else return gma.show.getobj.label(getName(str)) end
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



function macPrep(number, lines)
  gma.cmd('Store Macro 1.'..number)
  for i = 1, lines do
    gma.cmd('Store Macro 1.'..number..'.'..i)
  end
end



function createMacro(num, name, script)
  local macFile = {}
  macFile.name		= 'tempFile_createMacro.xml'
  macFile.dir		= gma.show.getvar('PATH')..'/'..'macros/'
  macFile.fullpath	= macFile.dir..macFile.name  
  
  local writeFile = io.open(macFile.fullpath, 'w')
  writeFile:write(script)
  writeFile:close()
  
  gma.cmd('Import \"'..macFile.name..'\" Macro '..num)
  os.remove(macFile.fullpath)
  
  gma.cmd('Label Macro '..num..' \"'..name..'\"')
end



function checkSpace(poolType, start, length) --checks if range of pool spaces is empty
  local finish = start + length - 1 --set our finishing point
  local errorMessage = poolType..' space conflict: please run plugin with a new '..poolType..' start slot'
  local emptyStatus = true
  for i = start, finish do
    if getClass(poolType..' '..tostring(i)) ~= nil then --if space is not empty
	  emptyStatus = false
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

--local shortcut variables
local print = gma.echo
local text = gma.textinput
local cmd = gma.cmd
local getHandle = gma.show.getobj.handle


return function() --START OF FUNCTION

--Set Sequence Type
local varName = text('sequence type', [[color, position, etc.]])
local varExec = varName..'Execs'
local varFadeMacros = varName..'FdMacros'

--Macro and Sequence numbers
local macStart_target = tonumber(text('starting macro', 'enter macro number'))
local seqStart = tonumber(text('starting sequence:', 'enter sequence number'))
local seqFinish = tonumber(text('ending sequence:', 'enter sequence number'))

--Populate list of fade times
local timeList = {}
local loopCt = 1
while true do
  local t = text('Fade Time #'..loopCt..':', '[PRESS ENTER WHEN DONE]')
  if t == '[PRESS ENTER WHEN DONE]' then
    break
  else
    timeList[loopCt] = t
	loopCt = loopCt + 1
  end
end


--CHECK FOR SPACE, RE-SET STARTING MACRO IF NOT ENOUGH SPACE FOUND--
local macLength = #timeList + 4
local macStart = advanceSpace('Macro', tonumber(macStart_target), macLength)
local macFinish = macStart + macLength - 1


--Create SetVar Macro -

--establish filepath
local dir = {}
dir.main = gma.show.getvar('PATH')..'/'
dir.macros	= dir.main..'macros/'

local fn = {}
fn.macTemp = 'tempFile_setVars.xml'

local file = {}
file.macTemp	= dir.macros..fn.macTemp

local filename = 'tempFile_setVars' 
local filepath = gma.show.getvar('PATH')..'/'..'macros'..'/'

--text for macro XML file
xmlText = [[
<?xml version="1.0" encoding="utf-8"?>
<MA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.malighting.de/grandma2/xml/MA" xsi:schemaLocation="http://schemas.malighting.de/grandma2/xml/MA http://schemas.malighting.de/grandma2/xml/3.1.2/MA.xsd" major_vers="3" minor_vers="1" stream_vers="2">
	<Info datetime="2016-07-10T12:08:13" showfile="NA" />
	<Macro index="1" name="Set ]]..varExec..[[">
		<Macroline index="0">
			<text>SetVar $]]..varExec..[[ = &quot;Sequence ]]..seqStart..[[ THRU ]]..seqFinish..[[ Cue THRU&quot;</text>
		</Macroline>
		<Macroline index="1">
			<text>SetVar $]]..varFadeMacros..[[ = &quot;Macro ]]..(macStart+1)..[[ THRU ]]..macFinish..[[&quot;</text>
		</Macroline>
	</Macro>
</MA>]]

--write XML file to disk
local file = assert(io.open(file.macTemp, 'w'))
file:write(xmlText)
file:close()

cmd('SelectDrive 1') --select the internal drive as default read path
cmd('import \"'..fn.macTemp..'\" Macro '..macStart) --load new macro into showfile
os.remove(filepath..filename..'.xml')             --delete temp .xml file from system


--create fade time macros
local macCurrent = macStart + 1
for i = 1, #timeList do
  macStore(macCurrent, 'Fade '..timeList[i]..'s')
  macLine(macCurrent, 1, 'Off $'..varFadeMacros..' - '..macCurrent)
  macLine(macCurrent, 2, 'Assign $'..varExec..' /fade = '..timeList[i], 'Go')
  macLine(macCurrent, 3, 'Top Macro '..macCurrent)
  macCurrent = macCurrent + 1
end

---- Disable Uninstall ----
macStore(macCurrent, 'DISABLE Uninstall')
macLine(macCurrent, 1, 'Assign Macro 1.'..macFinish..'.* /disabled=yes')
macLine(macCurrent, 2, 'Lock Macro '..macFinish)
macCurrent = macCurrent + 1


---- Enable Uninstall ----
local mac_lock = macCurrent
macStore(macCurrent, 'ENABLE Uninstall')
macLine(macCurrent, 1, 'Unlock Macro '..macFinish)
macLine(macCurrent, 2, 'Assign Macro 1.'..macFinish..'.* /disabled=no')
macCurrent = macCurrent + 1


---- Uninstall Macro ----
macStore(macCurrent, 'UNINSTALL FadeTimes')
macLine(macCurrent, 1, 'Delete Macro '..macStart..' Thru '..macFinish)
macLine(macCurrent, 2, 'SetVar $'..varFadeMacros..' =')

cmd('Macro '..macStart)
cmd('Macro '..mac_lock)

end --end of function