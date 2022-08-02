util.AddNetworkString("cosmWarn:SubmitWarn")
util.AddNetworkString("cosmWarn:EmitWarn")
util.AddNetworkString("cosmWarn:GetWarn")
util.AddNetworkString("cosmWarn:Send")
util.AddNetworkString("cosmWarn:Delete")

hook.Add("Initialize", "cosmWarn:InitializeDB", function()
sql.Query("CREATE TABLE WarnSystem(warn_id INTEGER PRIMARY KEY AUTOINCREMENT, Craison TEXT, desc TEXT, player_warn TEXT, adminWarn TEXT)")
end)

net.Receive("cosmWarn:SubmitWarn", function(len, adminWarn)
    local Craison = net.ReadString()
    local desc = net.ReadString()
    local pl = net.ReadString()
    local warn_date = os.date("%Hh:%Mm - %b/%a/%Y", os.time())


    if (Craison == "" or desc == "") then
        DarkRP.notify(adminWarn, 1, 3, "Vous devez renseigner toutes les informations")
    end

    sql.Query("INSERT INTO WarnSystem( warn_id, Craison , desc, player_warn , adminWarn ) VALUES( NULL, '".. sql.SQLStr(Craison) .. "','" .. sql.SQLStr(desc) .. "','" .. sql.SQLStr(pl) .. "','" .. warn_date .. "')")

    net.Start("cosmWarn:EmitWarn")
    net.WriteString(Craison)
    net.WriteString(desc)
    net.WriteString(pl)
    net.WriteString(warn_date)
    net.Send(adminWarn)

end)

net.Receive("cosmWarn:GetWarn", function(len, ply)
    local pl = net.ReadString()
    local steamid = sql.Query("SELECT warn_id, Craison , desc, player_warn , adminWarn FROM WarnSystem WHERE player_warn='".. sql.SQLStr(pl) .."'")
    net.Start("cosmWarn:Send")

    net.WriteUInt(#steamid, 15)
    for k, v in ipairs(steamid) do
        net.WriteString(v.Craison)
        net.WriteString(v.adminWarn)
        net.WriteString(v.desc)
        net.WriteInt(v.warn_id, 6)
    end
    net.Send(ply)


end)

net.Receive("cosmWarn:Delete", function(len, ply)
    local id = net.ReadInt(6)
    sql.Query("DELETE FROM WarnSystem WHERE warn_id=".. id .."")
end)


