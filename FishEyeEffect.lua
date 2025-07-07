
script_name('FishEyeEffect')
script_version_number(002)
script_author('Receiver & Nasif')
script_url('https://vk.com/supreme1696')

local imgui = require 'mimgui'
local new = imgui.new
local sizeX, sizeY = getScreenResolution()

local enabled = false
local locked = false


local showFOVMenu = new.bool()

local inicfg = require 'inicfg'
local config = inicfg.load({
    settings = {
        enabled = 1,
        fov = 90,
    }
}, "FovChanger.ini")
local enabled = new.bool(config.settings.enabled)
local X = new.float(config.settings.fov)

local newFrame = imgui.OnFrame(
	function() return showFOVMenu[0] end,
    function(player)	
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(220, 100), imgui.Cond.FirstUseEver)
		imgui.Begin('FOV Editor', showConfigMenu)
		imgui.SliderFloat("FOV", X, 0.0, 150.0)
                config.settings.fov = X[0]
		inicfg.save(config,"FovChanger.ini")
		imgui.End() 
	end
)

function main()
	repeat wait(0) until isSampAvailable()
	
	--[[_______________COMMANDS_______________]]--
	sampRegisterChatCommand('camm', function()
		enabled = not enabled
                config.settings.enabled = enabled[0]
		inicfg.save(config,"FovChanger.ini")
	end)

	sampRegisterChatCommand('fov', function()
		showFOVMenu[0] = not showFOVMenu[0]
	end)

	--[[_______________COMMANDS_______________]]--
	
	while true do
		wait(0)
		if enabled[0] then
			if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(2) then
				if not locked then 
					cameraSetLerpFov(90.0, 90.0, 990, 1)
					locked = true
				end
			else
				cameraSetLerpFov(math.ceil(X[0]), math.ceil(X[0]), 1000, 0)
				locked = false
			end
		end
	end
end

function msg(text)
	sampAddChatMessage(string.format('[%s] {ffffff}%s', thisScript().name, text), 0xFFCD5C5C)
end
