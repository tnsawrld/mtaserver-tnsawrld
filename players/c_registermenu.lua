local panel
local GetName = getPlayerName(localPlayer)

addEvent('register-menu:open', true)
addEventHandler('register-menu:open', root, function()
    setCameraMatrix(1280, -1300, 20, 1270, -1290, 15)
    fadeCamera(true, 5.0)

    showCursor(true)
    guiGetInputMode('no_binds')

    local x, y, width, height = GetScreenSize(300, 230)
    panel = guiCreateWindow(x, y, width, height, 'Register menu', false)
    guiWindowSetSizable(panel, false)
    guiWindowSetMovable(panel, false)

    local menuLabel = guiCreateLabel(40, 30, width - 20, 30, 'Halo ' ..GetName.. ', Anda bisa mendaftarkan \nakun anda dengan mengisi berikut', false, panel)
    
    local usernameLabel = guiCreateLabel(10, 70, width - 20, 30, 'Username : ', false, panel)
    guiLabelSetColor(usernameLabel, 40, 150, 40)
    guiSetFont(usernameLabel, "default-bold-small")

    local usernameInvalidLabel = guiCreateLabel(78, 70, width - 20, 30, ''..GetName.. '', false, panel)
    guiLabelSetColor(usernameInvalidLabel, 40, 150, 150)
    guiSetFont(usernameInvalidLabel, "default-bold-small")

    local passwordLabel = guiCreateLabel(10, 90, width - 20, 30, 'Password : ', false, panel)
    guiLabelSetColor(passwordLabel, 40, 150, 40)
    guiSetFont(passwordLabel, "default-bold-small")

    local passwordInvalidLabel = guiCreateLabel(78, 90, width - 20, 30, 'Passowrd Invalid ', false, panel)
    guiLabelSetColor(passwordInvalidLabel, 150, 40, 40)
    guiSetFont(passwordInvalidLabel, "default-bold-small")
    guiSetVisible(passwordInvalidLabel, false)

    local passwordInput = guiCreateEdit(10, 110, width - 20, 30, '', false, panel)
    guiEditSetMasked(passwordInput, true)

    local buttonRegister = guiCreateButton(10, 150, width / 2 - 15, 30, 'Register', false, panel)
    addEventHandler('onClientGUIClick', buttonRegister, function(button, state)
        if button ~= 'left' or state ~= 'up' then 
            return 
        end 

        local password = guiGetText(passwordInput)
        local InvalidInput = true 

        if not passwordInvalid(password) then 
            guiSetVisible(passwordInvalidLabel, true)
            InvalidInput = false 
        else 
            guiSetVisible(passwordInvalidLabel, false)
        end

        triggerServerEvent('register:auth', localPlayer, password)
    end)

    local buttonToLogin = guiCreateButton(width / 2 + 5, 150, width / 2, 30, 'Login', false, panel)
    addEventHandler('onClientGUIClick', buttonToLogin, function(button, state)
        triggerEvent('register-menu:close', localPlayer)
        triggerEvent('login-menu:open', localPlayer)
    end)

    local buttonClose = guiCreateButton(10 , 185, width - 20, 30, 'Close', false, panel)
end)

addEvent('register-menu:close', true)
addEventHandler('register-menu:close', root, function()
    destroyElement(panel)
    showCursor(false)
end)