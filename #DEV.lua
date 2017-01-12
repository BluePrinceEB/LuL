class "DEV"

function DEV:__init()
	Callback.Add("ObjectLoop", function(Obj) self:OnObjectLoop(Obj) end)
	Callback.Add("ProcessSpell", function(Obj, Spell) self:OnProcessSpell(Obj, Spell) end)
	Callback.Add("Draw", function() self:Draw() end)
end

function DEV:OnObjectLoop(Obj)
	if GetObjectType(Obj) == Obj_AI_Hero then
		if IsVisible(Obj) and IsObjectAlive(Obj) then
			local Origin = GetOrigin(Obj)
			local ScreenPos = WorldToScreen(1, Origin.x, Origin.y, Origin.z)
			if ScreenPos.flag then
				local V = 0

                for B = 0, 63 do
                	if GetBuffCount(Obj, B) > 0 then
                		V = V + 12
                		local BuffName = GetBuffName(Obj, B);
						local BuffCount = GetBuffCount(Obj, B);
                		DrawText(string.format("Buff List: Count: %d | Name: %s", BuffCount, BuffName),14, ScreenPos.x,ScreenPos.y+80+V, GoS.Cyan)
                	end
                end

				DrawText(string.format("Champion Name: %s", GetObjectName(Obj)), 14, ScreenPos.x, ScreenPos.y, GoS.White)
				DrawText(string.format("NetworkID:  0x%X", GetNetworkID(Obj)), 14, ScreenPos.x, ScreenPos.y+12, GoS.White)
				DrawText(string.format("(Q) Spell Name: %s", GetCastName(Obj,_Q)), 14, ScreenPos.x, ScreenPos.y+24, GoS.White)
				DrawText(string.format("(W) Spell Name: %s", GetCastName(Obj,_W)), 14, ScreenPos.x, ScreenPos.y+36, GoS.White)
				DrawText(string.format("(E) Spell Name: %s", GetCastName(Obj,_E)), 14, ScreenPos.x, ScreenPos.y+48, GoS.White)
				DrawText(string.format("(R) Spell Name: %s", GetCastName(Obj,_R)), 14, ScreenPos.x, ScreenPos.y+60, GoS.White)
			end
		end
	else
		local Origin = GetOrigin(Obj)
		local MousePos = GetMousePos()
		if GetDistance(Origin, MousePos) < 200 then
			local ScreenPos = WorldToScreen(1, Origin.x, Origin.y, Origin.z)
			if ScreenPos.flag then
				DrawCircle(Origin , 30, 0, 255, GoS.White)
				DrawText(string.format("Name: %s", GetObjectName(Obj)), 14, ScreenPos.x, ScreenPos.y+12, GoS.White)
				DrawText(string.format("Base Name: %s", GetObjectBaseName(Obj)), 14, ScreenPos.x, ScreenPos.y+24, GoS.White)
				--print(GetObjectBaseName(Obj))
				DrawText(string.format("Type: %s", GetObjectType(Obj)), 14, ScreenPos.x, ScreenPos.y+36, GoS.White)
				if GetNetworkID(Obj) > 0 then DrawText(string.format("NetworkID:  0x%X", GetNetworkID(Obj)), 14, ScreenPos.x, ScreenPos.y+48, GoS.White) end
			end
		end
	end
end

function DEV:OnProcessSpell(Obj, Spell)
	if Obj and Spell then
		if GetObjectType(Obj) == Obj_AI_Hero then
			print(string.format("'%s' casts '%s'; Windup: %.3f Animation: %.3f", GetObjectName(Obj), Spell.name, Spell.windUpTime, Spell.animationTime))
		end
	end
end

function DEV:Draw()
	local Origin = GetOrigin(myHero)
	local ScreenPos = WorldToScreen(1, Origin.x, Origin.y, Origin.z)
	if ScreenPos.flag then
    local V = 0

    for B = 0, 63 do
        if GetBuffCount(myHero, B) > 0 then
            V = V + 12
            local BuffName = GetBuffName(myHero, B);
		    local BuffCount = GetBuffCount(myHero, B);
                DrawText(string.format("Buff List: Count: %d | Name: %s", BuffCount, BuffName),14, ScreenPos.x,ScreenPos.y+80+V, GoS.Cyan)
            end
        end

		DrawText(string.format("Champion Name: %s", GetObjectName(myHero)), 14, ScreenPos.x, ScreenPos.y, GoS.White)
		DrawText(string.format("NetworkID:  0x%X", GetNetworkID(myHero)), 14, ScreenPos.x, ScreenPos.y+12, GoS.White)
		DrawText(string.format("(Q) Spell Name:  %s", GetCastName(myHero,_Q)), 14, ScreenPos.x, ScreenPos.y+24, GoS.White)
		DrawText(string.format("(W) Spell Name: %s", GetCastName(myHero,_W)), 14, ScreenPos.x, ScreenPos.y+36, GoS.White)
		DrawText(string.format("(E) Spell Name: %s", GetCastName(myHero,_E)), 14, ScreenPos.x, ScreenPos.y+48, GoS.White)
		DrawText(string.format("(R) Spell Name: %s", GetCastName(myHero,_R)), 14, ScreenPos.x, ScreenPos.y+60, GoS.White)
	end
end

DEV()

