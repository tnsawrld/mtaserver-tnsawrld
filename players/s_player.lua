local db = exports.dbserver:GetConnection()


addEventHandler('onPlayerJoin', root, function()
    local namePlayer = getPlayerName(source)
    local player = source

    --mengecek player sudah terdaftar atau belum
    dbQuery(function(accountCheck)
        local results = dbPoll(accountCheck, -1)
        if results and #results > 0 then 
            triggerClientEvent(player, 'login-menu:open', player)
            outputDebugString('Nama : ' ..namePlayer.. ' Terdaftar ke dalam database', 3)
        else
            triggerClientEvent(player, 'register-menu:open', player)
            outputDebugString('Nama : ' ..namePlayer.. ' Tidak terdaftar ke dalam database', 3)
        end
    end, db, 'SELECT username FROM player WHERE username = ?', namePlayer)
end)