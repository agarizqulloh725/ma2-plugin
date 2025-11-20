--*******************************************************************************************
-- This script tests the fixture library
--*******************************************************************************************

local function bash(cmd)
    -- popen not supported
    local tmpfile = os.tmpname();
    os.execute(cmd.." > "..tmpfile)
    local result = "";
    for line in io.lines(tmpfile) do
        result = line;
    end
    os.remove(tmpfile);
    if not result then
        error("bash cmd "..cmd.." could not be called from lua.")
    else
        result = string.gsub(result, '^%s+', '')
        result = string.gsub(result, '%s+$', '')
        result = string.gsub(result, '[\n\r]+', ' ')
        return result
    end
end

local function testFixtureLibrary(C,F,E)
    if not F then F=gma.feedback; end
    
    local hostsubtype = gma.network.gethostsubtype();
    if hostsubtype == "onPC" or gma.network.getprimaryip() == "10.0.255.65" then
        F("testFixtureLibrary will be skipped, wrong hosttype.")
        return;
    end
    
    local libraryPath = "/home/madevel/MALightingTechnology/gma2/actual/gma2/library"
    local cmd = 'ls '..libraryPath..' | wc -l';
    F('executing bash from lua: '..cmd)
    local ret = bash(cmd)
    F(ret)
    if tonumber(ret) < 7000 then
        error("Check fixture library! Count of fixtures is: "..ret)
    end
end

AssertFunctions[#AssertFunctions+1] = testFixtureLibrary;


return testFixtureLibrary