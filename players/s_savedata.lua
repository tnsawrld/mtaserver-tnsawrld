local db = exports.dbserver:GetConnection()

--Function untuk save semua data saat player disconnect/keluar dari server
local function SaveAllDataPlayer(player)
    local x, y, z = getElementPosition(player)
    local rx, ry, rz = getElementRotation(player)
    local id = getElementData(player, 'id')

    local status = dbExec(db, 'UPDATE player SET posx = ?, posy = ?, posz = ?, rotx = ?, roty = ?, rotz = ? WHERE id = ?', x, y, z, rx, ry, rz, id)
    if status then 
        outputDebugString('Berhasil menyimpan koordinat player!', 3)
    else 
        outputDebugString('Gagal menyimpan koordinat player', 1)
    end
end

addEventHandler('onPlayerQuit', root, function()
    SaveAllDataPlayer(source)
end)
