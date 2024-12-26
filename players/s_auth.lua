local db = exports.dbserver:GetConnection()
local SPAWN_X, SPAWN_Y, SPAWN_Z = 1280, -1300, 10
local ROT_X, ROT_Y, ROT_Z = 0, 0, 100

addEvent('register:auth', true)
addEventHandler('register:auth', root, function(password)
    local usernames = getPlayerName(source)
    local validation = true
    local player = source 
    local serial = getPlayerSerial(source)

    --mengecek username 
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

                --Menghash/encrypt password agar lebih aman
                passwordHash(password, 'bcrypt', {}, function(hashedPassword)
                    dbExec(db, 'INSERT INTO player (username, password, serial, posx, posy, posz, rotx, roty, rotz) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', usernames, hashedPassword, serial, SPAWN_X, SPAWN_Y, SPAWN_Z, ROT_X, ROT_Y, ROT_Z)
                    spawnPlayer(player, SPAWN_X, SPAWN_Y, SPAWN_Z)
                    setCameraTarget(player, player)
                    outputChatBox('Anda berhasil terdaftar!', player, 50, 255, 50)
                    
                    --Mengecek id pemain dari database
                    dbQuery(function(queryHandle)
                        local result = dbPoll(queryHandle, 0)
                        if result and #result > 0 then
                            local playerid = result[1]
                            if playerid and playerid.id then 
                                outputDebugString("Query berhasil, id: " .. tostring(playerid.id))
                            else 
                                outputDebugString("Gagal mengambil ID player dari database!")
                            end
                        end
                
                    end, db, 'SELECT id FROM player ORDER BY id DESC LIMIT 1')
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

    --Mengecek di database ada akun dari player atau tidak
    dbQuery(function(queryHandle)
        local result = dbPoll(queryHandle, -1)
        if result and #result > 0 then 
            local user = result[1]
            local hashedPassword = user.password
            local idplayer = user.id

            --Function untuk meload semua data player dari database
            local function LoadAllDataPlayer()
                spawnPlayer(player, user.posx, user.posy, user.posz)
                setCameraTarget(player, player)
                --Untuk mengeset id database 
                setElementData(player, 'id', user.id)
            end
            
            --Untuk memverifikasi password
            passwordVerify(passwords, hashedPassword, function(isValid)
                if isValid then 
                    outputChatBox('Anda berhasil login!', player, 50, 255, 50)
                    --Function di panggil saat player berhasil memasukkan passwrd
                    LoadAllDataPlayer()
                    outputDebugString('Berhasil menyimpan id', 3)
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