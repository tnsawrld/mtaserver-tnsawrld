local database


function ConnectDatabase()
    database = dbConnect('sqlite', ':/tansa.db')
    if database then 
        outputDebugString('berhasil terhubung kedalam database', 3)
    else 
        outputDebugString('database tak berhasil tersambung', 1)
    end
end 

addEventHandler('onResourceStart', resourceRoot, ConnectDatabase)

function GetConnection()
    return database
end
