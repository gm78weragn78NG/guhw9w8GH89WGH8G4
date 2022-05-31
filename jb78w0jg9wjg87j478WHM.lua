if getgenv().SafeOutputV2 then return end
getgenv().SafeOutputV2 = true

hookfunction((gcinfo or collectgarbage), function(...)
	return math.random(200,350) -- memory check
end)

if not syn then
	if not string.match(identifyexecutor(), 'ScriptWare') then 
		return 
	end
end

getgenv().ExecuteScript = function(sc) local su, o = pcall(function() loadstring(sc)() end) if(not su) then error(tostring(o)..'\n') end end

local ConsoleOpened = false

local function SecureOutput(Message, Color)
	if ConsoleOpened then
		if syn then
			rconsoleprint('@@'..string.upper(tostring(Color))..'@@')
			rconsoleprint(tostring(Message))
		else
			rconsoleprint(tostring(Message), string.lower(tostring(Color)))
		end
	end
end

local function HandleVar(Arg)
	local str = ''
	for i=1,#Arg do
		str = str..tostring(Arg[i])..' '
	end
	return str
end

local function ClearConsole()
	local String = ' \n'
	for i=1, 20 do
		String = String .. ' \n'
	end
	SecureOutput(String, 'white')
	SecureOutput('_________________________________________________________________________________________________\n', 'green')
end

local OldPrint
OldPrint = hookfunction(print, newcclosure(function(...)
	if(checkcaller() == true) then
		SecureOutput(tostring(HandleVar({...}))..'\n', 'white')
	else
		OldPrint(...)
	end
end))

local OldWarn
OldWarn = hookfunction(warn, newcclosure(function(...)
	if(checkcaller() == true) then
		SecureOutput(tostring(HandleVar({...}))..'\n', 'yellow')
	else
		OldWarn(...)
	end
end))

local OldError
OldError = hookfunction(error, newcclosure(function(...)
	if(checkcaller() == true) then
		SecureOutput(tostring(HandleVar({...}))..'\n', 'red')
	else
		OldError(...)
	end
end))

game:GetService('UserInputService').InputBegan:Connect(function(Key, GameProcessed)
	if(GameProcessed) then return end
	if(Key.KeyCode == Enum.KeyCode.Insert) then
		if ConsoleOpened == false then
			ConsoleOpened = true
			if not syn then
				rconsolecreate()
			end
			SecureOutput('Print, Warn, and Error are now hooked. All external messages will appear in the external console.\n', 'green')
			SecureOutput('_________________________________________________________________________________________________\n', 'green')
		else
			ClearConsole()
		end
	end
end)
