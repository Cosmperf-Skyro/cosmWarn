net.Receive("cosmWarn:Send", function(len, ply)
    local warns = {}
    local warns_length = net.ReadUInt(15)

    for i=1, warns_length do
        local Craison = net.ReadString()
        local date = net.ReadString()
        local desc = net.ReadString()
        local id = net.ReadInt(6)

        warns[#warns +1] = {Craison, date, desc, id}


        local panel_warn = vgui.Create("DPanel",  cosmWarn.scroll_warn)
        panel_warn:SetSize(respW(800), respH(120)) 
        panel_warn:Dock(TOP)
        panel_warn:DockMargin(0,0,0,respH(5))   
        
        function panel_warn:Paint(iW, iH)
            surface.SetDrawColor( TLib:C( 1 ) )
            surface.DrawRect( 0, 0, iW, iH )

            draw.SimpleText("Raison de l'avertissement : ".. Craison, sSubtitleFont, respW(10), respH(10), color_white, TEXT_ALIGN_LEFT)
            draw.SimpleText("Information supplémentaire : ".. desc, sSubtitleFont, respW(10), respH(40), color_white, TEXT_ALIGN_LEFT)
            draw.SimpleText("Date de l'avertissement : ".. date, sSubtitleFont, respW(10), respH(70), color_white, TEXT_ALIGN_LEFT)
        end

        local delete_warn = vgui.Create("TLButton", panel_warn)
        delete_warn:SetSize(respW(150), respH(40))
        delete_warn:SetPos(respW(535), respH(10))
        delete_warn:SetText("Supprimer")

        function delete_warn:DoClick()
            net.Start("cosmWarn:Delete")
                net.WriteInt(id, 6)
            net.SendToServer()
            main:Close()
        end



    end
end)

