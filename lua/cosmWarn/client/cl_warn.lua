sSubtitleFont = ( sSubtitleFont or "TLib.Standard" )

hook.Add( "OnPlayerChat", "cosmWarn:WarnMenu", function( ply, strText, bTeam, bDead ) 
    if ( ply != LocalPlayer() ) then return end

	strText = string.lower( strText ) -- make the string lower case

	if ( strText == cosmWarn.Config.Command ) then -- if the player typed /hello then

        if cosmWarn.Config.Admin[LocalPlayer():GetUserGroup()] then
            
        cosmWarn.main = vgui.Create("TLFrame")    
        cosmWarn.allPlayer = vgui.Create("TLScroll", cosmWarn.main)
        cosmWarn.warn_panel = vgui.Create("DPanel", cosmWarn.main)
        cosmWarn.warn_avatar = vgui.Create("AvatarImage", cosmWarn.warn_panel)
        cosmWarn.add_warn = vgui.Create("TLButton", cosmWarn.warn_panel)



        cosmWarn.main:SetSize(respW(1200), respH(700))
        cosmWarn.main:Center()
        cosmWarn.main:MakePopup()
        cosmWarn.main:SetDraggable(false)
        cosmWarn.main:ShowCloseButton(true)
        cosmWarn.main:SetHeader("COSMWARN - CASIER DES WARNS")

        cosmWarn.allPlayer:SetSize(respW(300), respH(600))
        cosmWarn.allPlayer:SetPos(respW(10), respH(70))

        for k, v in pairs(player.GetAll()) do
            local btnPlayer = vgui.Create("TLButton", cosmWarn.allPlayer)
            btnPlayer:SetSize(respW(250), respH(50))
            btnPlayer:Dock(TOP)
            btnPlayer:DockMargin(0,0,0,respH(5))
            btnPlayer:SetText(v:Name())
            
            function btnPlayer:DoClick()
                net.Start("cosmWarn:GetWarn")
                    net.WriteString(v:SteamID())
                net.SendToServer()



                warn_panel:SetSize(respW(800), respH(600))
                warn_panel:SetPos(respW(360), respH(70))  
                    function warn_panel:Paint(iW, iH)
                        surface.SetDrawColor( TLib:C( 0 ) )
                        surface.DrawRect( 0, 0, iW, iH )

                        draw.SimpleText(v:Name(), sSubtitleFont, respW(100), respH(10), color_white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(v:SteamID(), sSubtitleFont, respW(100), respH(35), color_white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(v:SteamID64(), sSubtitleFont, respW(100), respH(60), color_white, TEXT_ALIGN_LEFT)
                    end



                



                    cosmWarn.warn_avatar:SetSize(respW(64), respH(64))
                    cosmWarn.warn_avatar:SetPos(respW(10), respH(10))
                    cosmWarn.warn_avatar:SetPlayer(v, 64)

                    cosmWarn.add_warn:SetSize(respW(300), respH(50))
                    cosmWarn.add_warn:SetPos(respW(480), respH(10))
                    cosmWarn.add_warn:SetText("Ajouter un avertissement")

                    cosmWarn.scroll_warn = vgui.Create("TLScroll", cosmWarn.warn_panel)
                    cosmWarn.scroll_warn:SetSize(respW(700), respH(500))
                    cosmWarn.scroll_warn:SetPos(respW(10), respH(120))






                    

                        function add_warn:DoClick()
                            local panel_warn = vgui.Create("TLFrame")
                            panel_warn:SetSize(respW(700), respH(400))
                            panel_warn:Center()
                            panel_warn:MakePopup()
                            panel_warn:SetDraggable(false)
                            panel_warn:ShowCloseButton(true)
                            panel_warn:SetHeader("Ajouter Un Avertissement")

                            local Craison = vgui.Create("TLComboBox", panel_warn)
                            Craison:SetSize(respW(400), respH(50))
                            Craison:SetPos(respW(150), respH(100))
                            Craison:SetValue("Choisir une raison")

                            for k, raisonData in ipairs(cosmWarn.Config.Raison) do
                                Craison:AddChoice(raisonData)
                            end

                            local desc = vgui.Create("TLTextEntry", panel_warn)
                            desc:SetSize(respW(500), respH(150))
                            desc:SetPos(respW(100), respH(160))
                            desc:IsMultiline(true)
                            desc:SetPlaceholderText("Information supplémentaire")

                            local submit = vgui.Create("TLButton", panel_warn)
                            submit:SetSize(respW(400), respH(60))
                            submit:SetPos(respW(150), respH(320))
                            submit:SetText("Soumettre l'avertissement")

                            function submit:DoClick()
                                net.Start("cosmWarn:SubmitWarn")
                                    net.WriteString(Craison:GetValue())
                                    net.WriteString(desc:GetValue())
                                    net.WriteString(v:SteamID())
                                net.SendToServer()
                                panel_warn:Close()
                                main:Close()
                            end

                            

                        end

            end

        end
		
        
        end




		return true -- this suppresses the message from being shown
	end
end )
