local db = exports.dbserver:GetConnection()

addEvent('register:auth', true)
addEventHandler('register:auth', root, function(password)
    local usernames = getPlayerName(source)
    local validation = true
    local player = source 
    local serial = getPlayerSerial(source)

    dbQuery(function(queryHandle)
        local result = dbPoll(queryHandle, -1)
        if result and #result > 0 then 
            outputChatBox('Username sudah digunakan!', source, 255, 50, 50)
            validation = false 
            return
        else 
            if validation == true then 
                if not isInvalidPassword(password) then 
                    return outputChatBox('Password invalid atau salah')
                end 

                passwordHash(password, 'bcrypt', {}, function(hashedPassword)
                    dbExec(db, 'INSERT INTO player (username, password, serial) VALUES (?, ?, ?)', usernames, hashedPassword, serial)
                    spawnPlayer(player, 1280, -1300, 10)
                    setCameraTarget(player, player)
                    outputChatBox('Anda berhasil terdaftar!', player, 50, 255, 50)
                    return triggerClientEvent(player, 'register-menu:close', player)
                end)
            else 
                return
            end
        end
    end, db, 'SELECT id FROM player WHERE username = ?', usernames)
end)

addEvent('login:auth', true)
addEventHandler('login:auth', root, function(passwords)
    local usernames = getPlayerName(source)
    local player = source

    dbQuery(function(queryHandle)
        local result = dbPoll(queryHandle, -1)
        if result and #result > 0 then 
            local user = result[1]
            local hashedPassword = user.password

            passwordVerify(passwords, hashedPassword, function(isValid)
                if isValid then 
                    outputChatBox('Anda berhasil login!', player, 50, 255, 50)
                    spawnPlayer(player, 1280, -1300, 10)
                    setCameraTarget(player, player)
                    return triggerClientEvent(player, 'login-menu:close', player)
                else 
                    outputChatBox('Password invalid atau salah!', player, 255, 50, 50)
                end
            end)
        else 
           outputChatBox('Akun tak ditemukan!', player, 255, 50, 50)
        end
    end, db, 'SELECT * FROM player WHERE username = ?', usernames)    
end)