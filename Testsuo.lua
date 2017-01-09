----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

OnLoad(function() Mid_Bundle() end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "Mid_Bundle"

function Mid_Bundle:__init()
	self:LoadPutin()
	self:LoadOPred()
    self:LoadGPred()
	self:LoadChampion()
end

function Mid_Bundle:LoadChampion()
    if _G["Mid_Bundle_"..GetObjectName(myHero)] then
    	self.Config = MenuConfig("MidBundle", "[S] Mid Bundle")
        self.Champion = _G["Mid_Bundle_"..GetObjectName(myHero)](self.Config)
    end
end

function Mid_Bundle:LoadPutin()
	if FileExist(COMMON_PATH.."\\Putin.lua") then
	    require("Putin")
	else
	    PrintChat("[Yasuo] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/BluePrinceEB/GoS/master/Common/Putin.lua", COMMON_PATH .. "Putin.lua", function() PrintChat("[Yasuo] Download Completed! x2 F6") return end)
	    return
	end
end

function Mid_Bundle:LoadOPred()
	if FileExist(COMMON_PATH.."\\OpenPredict.lua") then
	    require("OpenPredict")
	else
	    PrintChat("[Yasuo] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/Jo7j/GoS/master/OpenPredict/OpenPredict.lua", COMMON_PATH .. "OpenPredict.lua", function() PrintChat("[Yasuo] Download Completed! x2 F6") return end)
	    return
	end
end

function Mid_Bundle:LoadGPred()
	if FileExist(COMMON_PATH.."\\GPrediction.lua") then
	    require("GPrediction")
	else
	    PrintChat("[Yasuo] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/KeVuong/GoS/master/Common/GPrediction.lua", COMMON_PATH .. "GPrediction.lua", function() PrintChat("[Yasuo] Download Completed! x2 F6") return end)
	    return
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "Mid_Bundle_Yasuo"

function Mid_Bundle_Yasuo:__init(Config)
	self:LoadMenu(Config)
	self:Variables()
	self:CallBacks()
end

function Mid_Bundle_Yasuo:LoadMenu(Config)
	Config:SubMenu("Yasuo", "[S] Yasuo")
    self.Menu = Config[GetObjectName(myHero)]

    self.Menu:SubMenu("Combo", "[Yasuo] Combo")
        self.Menu.Combo:SubMenu("Q", "-> Q")
            self.Menu.Combo.Q:Boolean("Use", "Enabled", true)
            self.Menu.Combo.Q:DropDown("HitChance", "Q3 Hit Chance", 2, {"Low", "Medium", "High"})
        self.Menu.Combo:SubMenu("E", "-> E")
            self.Menu.Combo.E:Boolean("Use", "Enabled", true)
            self.Menu.Combo.E:Slider("Lock", "Don't E Into X Enemies", 3, 1, 5, 1)
            self.Menu.Combo.E:Boolean("Turret", "Turret Check", true)
        self.Menu.Combo:SubMenu("R", "-> R")
            self.Menu.Combo.R:Boolean("Use", "Enabled", true)
            self.Menu.Combo.R:Boolean("Turret", "Turret Check", true)
            self.Menu.Combo.R:Boolean("Killable", "Only When Killable")
            self.Menu.Combo.R:Slider("Hit", "Use When X Enemies", 2, 1, 5, 1)
    self.Menu:SubMenu("Harass", "[Yasuo] Harass")
        self.Menu.Harass:SubMenu("Q", "-> Q")
            self.Menu.Harass.Q:Boolean("Use", "Enabled", true)
            self.Menu.Harass.Q:DropDown("HitChance", "Q3 Hit Chance", 2, {"Low", "Medium", "High"})
        self.Menu.Harass:SubMenu("E", "-> E")
            self.Menu.Harass.E:Boolean("Use", "Enabled", true)
            self.Menu.Harass.E:Slider("Lock", "Don't E Into X Enemies", 3, 1, 5, 1)
            self.Menu.Harass.E:Boolean("Turret", "Turret Check", true)
    self.Menu:SubMenu("LastHit", "[Yasuo] Last Hit")
        self.Menu.LastHit:SubMenu("Q", "-> Q")
            self.Menu.LastHit.Q:Boolean("Use", "Enabled", true)
        self.Menu.LastHit:SubMenu("E", "-> E")
            self.Menu.LastHit.E:Boolean("Use", "Enabled", true)
            self.Menu.LastHit.E:Boolean("Turret", "Turret Check", true)
    self.Menu:SubMenu("LaneClear", "[Yasuo] Lane Clear")
        self.Menu.LaneClear:SubMenu("Q", "-> Q")
            self.Menu.LaneClear.Q:Boolean("Use", "Enabled", true)
            self.Menu.LaneClear.Q:Slider("Hit", "Use Q3 If Can Hit X Minions", 3, 1, 6, 1)
        self.Menu.LaneClear:SubMenu("E", "-> E")
            self.Menu.LaneClear.E:Boolean("Use", "Enabled", true)
            self.Menu.LaneClear.E:DropDown("Mode", "Mode", 2, {"Always", "Last Hit"})
            self.Menu.LaneClear.E:Boolean("Turret", "Turret Check", true)
    self.Menu:SubMenu("JungleClear", "[Yasuo] Jungle Clear")
        self.Menu.JungleClear:SubMenu("Q", "-> Q")
            self.Menu.JungleClear.Q:Boolean("Use", "Enabled", true)
        self.Menu.JungleClear:SubMenu("E", "-> E")
            self.Menu.JungleClear.E:Boolean("Use", "Enabled", true)
    self.Menu:SubMenu("KillSteal", "[Yasuo] Kill Steal")
        self.Menu.KillSteal:SubMenu("Q", "-> Q")
            self.Menu.KillSteal.Q:Boolean("Use", "Enabled", true)
        self.Menu.KillSteal:SubMenu("E", "-> E")
            self.Menu.KillSteal.E:Boolean("Use", "Enabled", true)
    self.Menu:SubMenu("WindWall", "[Yasuo] Wind Wall")
        self.Menu.WindWall:SubMenu("SkillShots", "SkillShots")
        self.Menu.WindWall:Boolean("Use", "Enabled", true)
        self.Menu.WindWall:Boolean("Combo", "Use Wall Only in Combo")
        self.Menu.WindWall:Slider("Danger", "Use Wall If Danger Level:", 1, 1, 5, 1)
            self:WindWall()
        
    self.Menu:SubMenu("Prediction", "[Yasuo] Prediction")
        self.Menu.Prediction:DropDown("CP", "Choose Prediction: ", 2, {"Open Prediction", "GPrediction", "GoS Prediction"})
end

function Mid_Bundle_Yasuo:Variables()
	self.Q1 = { delay = .25, speed = math.huge, width = 40,  range = 475 }
	self.Q3 = { delay = .25, speed = math.huge, width = 100, range = 1000 }
	self.W  = {}
	self.E  = { delay = .25, speed = math.huge, width = 40,  range = 475 }
	self.R  = { delay = 0,   speed = math.huge, width = 40,  range = 1200 }

    self.QT, self.WT, self.ET, self.RT = 0, 0, 0, 0
	self.DashBuffCount = 666
	self.KUP = 0
end

function Mid_Bundle_Yasuo:WindWall()
	for i = 1, heroManager.iCount,1 do
        local hero = heroManager:getHero(i)
        if hero.team ~= myHero.team then
            if Mid_Bundle_Spells[hero.charName] ~= nil then
                for _, skillshot in pairs(Mid_Bundle_Spells[hero.charName].skillshots) do
                    if skillshot.blockable == true then
                    	local SlotToString = {[-6] = "P", [-5] = "R2", [-4] = "E2", [-3] = "W2", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
                        self.Menu.WindWall.SkillShots:SubMenu(skillshot.spellName, hero.charName .. " - " .. skillshot.name)
                        self.Menu.WindWall.SkillShots[skillshot.spellName]:Boolean("Block", "Enabled", true)
                        self.Menu.WindWall.SkillShots[skillshot.spellName]:Slider("Danger", "Danger Level", skillshot.danger, 1, 5, 1)
                    end
                end
            end
        end
    end
end

function Mid_Bundle_Yasuo:CallBacks()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
	Callback.Add("SpellCast", function(spell) self:SpellCast(spell) end)
	Callback.Add("CreateObj", function(Obj) self:CreateObj(Obj) end)
	Callback.Add("DeleteObj", function(Obj) self:DeleteObj(Obj) end)
	Callback.Add("UpdateBuff", function(unit, buff) self:UpdateBuff(unit, buff) end)
	Callback.Add("RemoveBuff", function(unit, buff) self:RemoveBuff(unit, buff) end)
	Callback.Add("ProcessSpell", function(unit, spell) self:ProcessSpell(unit, spell) end)
end

function Mid_Bundle_Yasuo:Tick()
	self:Update()

	if not IsDead(myHero) then
		local target = GetCurrentTarget()
		if Mode() == "Combo" then
			self:Combo(target)
		elseif Mode() == "Harass" then
			self:Harass(target)
		elseif Mode() == "LastHit" then
			self:LastHit()
		elseif Mode() == "LaneClear" then
			self:LaneClear()
			self:JungleClear()
		end
		self:KillSteal()
	end
end

function Mid_Bundle_Yasuo:Combo(target)
	self:CastR(target)
	if self.Menu.Combo.E.Use:Value() and EnemiesAround(myHero, 1250) <= self.Menu.Combo.E.Lock:Value() then
		if self.Menu.Combo.E.Turret:Value() then
			if not UnderTurret(target, enemyTurret) then
				self:CastE1(target)
				self:CastE2(target)
			end
		else
			self:CastE1(target)
			self:CastE2(target)
		end
	end
	if self.Menu.Combo.Q.Use:Value() then
		self:CastQ1(target)
		self:CastQ1_Circle(target)
		self:CastQ3(target)
		self:CastQ3_Circle(target)
	end
end

function Mid_Bundle_Yasuo:Harass(target)
	if self.Menu.Harass.E.Use:Value() and EnemiesAround(myHero, 1250) <= self.Menu.Harass.E.Lock:Value() then
		if self.Menu.Harass.E.Turret:Value() then
			if not UnderTurret(target, enemyTurret) then
				self:CastE1(target)
				self:CastE2(target)
			end
		else
			self:CastE1(target)
			self:CastE2(target)
		end
	end
	if self.Menu.Harass.Q.Use:Value() then
		self:CastQ1(target)
		self:CastQ1_Circle(target)
		self:CastQ3(target)
		self:CastQ3_Circle(target)
	end
end

function Mid_Bundle_Yasuo:LastHit()
	for _, Minion in pairs(Minions.Enemy) do
		if self.Menu.LastHit.Q.Use:Value() then
			if self:Q_Damage() > Minion.health then
				self:CastQ1(Minion)
			end
		end
		if self.Menu.LastHit.E.Use:Value() then
			if self.Menu.LastHit.E.Turret:Value() then
				if not UnderTurret(self:DashEndPos(Minion), enemyTurret) then
					if self:E_Damage() > Minion.health then
				        self:CastE2(Minion)
			        end
				end
			else
				if self:E_Damage() > Minion.health then
				    self:CastE2(Minion)
			    end
			end
		end
	end
end

function Mid_Bundle_Yasuo:LaneClear()
    for _, Minion in pairs(Minions.Enemy) do
    	if self.Menu.LaneClear.Q.Use:Value() then
    		self:CastQ1(Minion)
    		self:CastQ1_Circle(Minion)
    	end

		if self.Menu.LaneClear.E.Mode:Value() == 2 then
			if self.Menu.LaneClear.E.Use:Value() then
			    if self.Menu.LaneClear.E.Turret:Value() then
				    if not UnderTurret(self:DashEndPos(Minion), enemyTurret) then
					    if self:E_Damage() > Minion.health then
				            self:CastE2(Minion)
			            end
				    end
			    else
				    if self:E_Damage() > Minion.health then
				        self:CastE2(Minion)
			        end
			    end
		    end
		elseif self.Menu.LaneClear.E.Mode:Value() == 1 then
			if self.Menu.LaneClear.E.Use:Value() then
			    if self.Menu.LaneClear.E.Turret:Value() then
				    if not UnderTurret(self:DashEndPos(Minion), enemyTurret) then
					    self:CastE2(Minion)
				    end
			    else
				    self:CastE2(Minion)
			    end
		    end
		end
    end

	local Pos, Hit = GetLineFarmPos(self.Q3.range, self.Q3.width, Minions.Enemy)
	if Hit >= self.Menu.LaneClear.Q.Hit:Value() then
		if self:IsQ3() and self.Menu.LaneClear.Q.Use:Value() then
		    if self.Q3.Ready and self.ET+500<GetTickCount() then
		    	CastSkillShot(_Q, Pos)
		    end
		end
	end
end

function Mid_Bundle_Yasuo:JungleClear()
	for _, Minion in pairs(Minions.Jungle) do
		if self.Menu.JungleClear.Q.Use:Value() then
    		self:CastQ1(Minion)
    		self:CastQ1_Circle(Minion)
    		self:CastQ3(Minion)
    		self:CastQ3_Circle(Minion)
    	end
    	if self.Menu.JungleClear.E.Use:Value() then
    		self:CastE2(Minion)
    	end
	end
end

function Mid_Bundle_Yasuo:KillSteal()
	for _, Enemy in pairs(GetEnemyHeroes()) do
		if self.Menu.KillSteal.Q.Use:Value() then
			if myHero:CalcDamage(Enemy, self:Q_Damage()) > Enemy.health then
				self:CastQ1(Enemy)
				self:CastQ3(Enemy)
			end
		end
		if self.Menu.KillSteal.E.Use:Value() then
			if myHero:CalcMagicDamage(Enemy, self:E_Damage()) > Enemy.health then
				self:CastE2(Enemy)
			end
		end
	end
end

function Mid_Bundle_Yasuo:Update()
	self:IsQ1()
	self:IsQ3()
	self:Damage()
	self:CD()
end

function Mid_Bundle_Yasuo:CD()
	self.Q1.Ready = myHero:CanUseSpell(_Q) == READY
	self.Q3.Ready = myHero:CanUseSpell(_Q) == READY
	self.W.Ready  = myHero:CanUseSpell(_W) == READY
	self.E.Ready  = myHero:CanUseSpell(_E) == READY
	self.R.Ready  = myHero:CanUseSpell(_R) == READY
end

function Mid_Bundle_Yasuo:IsQ1()
	return myHero:GetSpellData(_Q).toggleState == 0
end

function Mid_Bundle_Yasuo:IsQ3()
	return myHero:GetSpellData(_Q).toggleState == 2
end

function Mid_Bundle_Yasuo:Damage()
	self:Q_Damage()
	self:E_Damage()
	self:R_Damage()
end

function Mid_Bundle_Yasuo:Q_Damage()
	local Q = 0 + 20 * myHero:GetSpellData(_Q).level + myHero.totalDamage
	if GetCritChance(myHero) >= 0.9 then
		Q = Q + Q * .5
	end
	return Q
end

function Mid_Bundle_Yasuo:E_Damage()
	local E = 50 + 20 * myHero:GetSpellData(_E).level + myHero.ap * .6
	local TotalDamage
	if self.DashBuffCount == 666 then
		TotalDamage = E 
	elseif self.DashBuffCount == 0 then
		TotalDamage = E + E * .25
	elseif self.DashBuffCount > 0 then
		TotalDamage = E + E * .5
	end
	return TotalDamage
end

function Mid_Bundle_Yasuo:R_Damage()
	local R = 100 + 100 * myHero:GetSpellData(_R).level + GetBonusDmg(myHero) * 1.5
	return R
end

function Mid_Bundle_Yasuo:DashEndPos(target)
    if GetDistance(myHero, target) < 410 then
        Point = myHero + (Vector(target) - myHero):normalized() * 485
    else 
        Point = myHero + (Vector(target) - myHero):normalized() * (GetDistance(myHero,target) + 65)
    end
    return Point
end

function Mid_Bundle_Yasuo:HeroForGap(target)
	local ClosestHero = nil
	local NearestDistance = 0

	for _, Enemy in pairs(GetEnemyHeroes()) do
		if not Enemy.dead then
			if GetDistance(Enemy) <= 475 then
				if GetDistance(self:DashEndPos(Enemy), target) < GetDistance(target) and NearestDistance < GetDistance(Enemy) then
					NearestDistance = GetDistance(Enemy)
                    ClosestHero = Enemy
				end
			end
		end
	end
    return ClosestHero
end

function Mid_Bundle_Yasuo:MinionForGap(target)
	local ClosestMinion = nil
	local NearestDistance = 0

	for _, Minion in pairs(Minions.Enemy) do
		if not Minion.dead then
			if GetDistance(Minion) <= 375 then
				if GetDistance(self:DashEndPos(Minion), target) < GetDistance(target) and NearestDistance < GetDistance(Minion) then
					NearestDistance = GetDistance(Minion)
                    ClosestMinion = Minion
				end
			end
		end
	end
    return ClosestMinion
end

function Mid_Bundle_Yasuo:CastQ1(target)
	if self:IsQ1() then
		if self.Q1.Ready and ValidTarget(target, self.Q1.range) and self.ET+500<GetTickCount() then
			if self.Menu.Prediction.CP:Value() == 1 then
				local Data       = { range = self.Q1.range, speed = self.Q1.speed, width = self.Q1.width, delay = self.Q1.delay }
				local Prediction = GetPrediction(target, Data)
				if Prediction and Prediction.hitChance >= 0 then
					CastSkillShot(_Q, Prediction.castPos)
				end
			elseif self.Menu.Prediction.CP:Value() == 2 then
				local Data = { range = self.Q1.range, speed = self.Q1.speed, radius = self.Q1.width/2, delay = self.Q1.delay, type = "line" }
				local Prediction = _G.gPred:GetPrediction(target, myHero, Data, nil, false)
		        if Prediction and Prediction.HitChance >= 0 then
			        CastSkillShot(_Q, Prediction.CastPosition)
		        end
			elseif self.Menu.Prediction.CP:Value() == 3 then
				local Prediction = GetPredictionForPlayer(myHero, target, GetMoveSpeed(target), self.Q1.speed, self.Q1.delay, self.Q1.range, self.Q1.width, false, true)
		        if Prediction and Prediction.HitChance == 1 then
			        CastSkillShot(_Q, Prediction.PredPos)
		        end
			end
		end
	end
end

function Mid_Bundle_Yasuo:CastQ1_Circle(target)
	if self:IsQ1() then
		if self.Q1.Ready and ValidTarget(target) and target:DistanceTo(myHero) <= 345 then
			if self.ET+1000 > GetTickCount() then
				CastSkillShot(_Q, target)
			end
		end
	end
end

function Mid_Bundle_Yasuo:CastQ3(target)
	if self:IsQ3() then
		if self.Q3.Ready and ValidTarget(target, self.Q3.range) and self.ET+500<GetTickCount() then
			if self.Menu.Prediction.CP:Value() == 1 then
				local Data       = { range = self.Q3.range, speed = self.Q3.speed, width = self.Q3.width, delay = self.Q3.delay }
				local Prediction = GetPrediction(target, Data)
				if Prediction and Prediction.hitChance >= 0 then
					CastSkillShot(_Q, Prediction.castPos)
				end
			elseif self.Menu.Prediction.CP:Value() == 2 then
				local Data = { range = self.Q3.range, speed = self.Q3.speed, radius = self.Q3.width/2, delay = self.Q3.delay, type = "line", col = {"yasuowall"} }
				local Prediction = _G.gPred:GetPrediction(target, myHero, Data, nil, true)
		        if Prediction and Prediction.HitChance >= 0 then
			        CastSkillShot(_Q, Prediction.CastPosition)
		        end
			elseif self.Menu.Prediction.CP:Value() == 3 then
				local Prediction = GetPredictionForPlayer(myHero, target, GetMoveSpeed(target), self.Q3.speed, self.Q3.delay, self.Q3.range, self.Q3.width, false, true)
		        if Prediction and Prediction.HitChance == 1 then
			        CastSkillShot(_Q, Prediction.PredPos)
		        end
			end
		end
	end
end

function Mid_Bundle_Yasuo:CastQ3_Circle(target)
	if self:IsQ3() then
		if self.Q3.Ready and ValidTarget(target) and target:DistanceTo(myHero) <= 345 then
			if self.ET+1000 > GetTickCount() then
				CastSkillShot(_Q, target)
			end
		end
	end
end

function Mid_Bundle_Yasuo:CastE1(target)
	if GetDistance(myHero, target) <= 1500 then
	    if EnemiesAround(myHero, 1600) > 0 then
		    if GetDistance(target) >= 500 then
			    local Pos = self:MinionForGap(target)
			    if self.E.Ready and Pos then 
                    CastTargetSpell(Pos, _E)
                end
		    end
	    end
	    if GetDistance(target) >= 1000 then
		    local Pos = self:MinionForGap(GetMousePos())
		    if self.E.Ready and Pos then
			    if Pos.networkID ~= target.networkID then
				    CastTargetSpell(Pos, _E)
			    end
		    end
	    end
    end
end

function Mid_Bundle_Yasuo:CastE2(target)
	if self.E.Ready and ValidTarget(target, self.E.range) then
		if target:DistanceTo(myHero) >= 175 then
			CastTargetSpell(target, _E)
		end
	end
end

function Mid_Bundle_Yasuo:CastR(target)
	if self.R.Ready and ValidTarget(target, self.R.range) then
		if self.Menu.Combo.R.Use:Value() then
			if self.Menu.Combo.R.Turret:Value() then
				if not UnderTurret(target, enemyTurret) then
					if self.Menu.Combo.R.Killable:Value() then
					    if myHero:CalcDamage(target, self:R_Damage() + self:Q_Damage()) > target.health then
						    if self.KUP >= self.Menu.Combo.R.Hit:Value() then
							    CastSpell(_R)
						    end
					    end
				    else
					    if self.KUP >= self.Menu.Combo.R.Hit:Value() then
							CastSpell(_R)
						end
				    end
				end
			else
				if self.Menu.Combo.R.Killable:Value() then
					if myHero:CalcDamage(target, self:R_Damage()) > target.health then
						if self.KUP >= self.Menu.Combo.R.Hit:Value() then
							CastSpell(_R)
						end
					end
				else
					if self.KUP >= self.Menu.Combo.R.Hit:Value() then
					    CastSpell(_R)
				    end
				end
			end
		end
	end
end

function Mid_Bundle_Yasuo:CreateObj(Obj)
	if Obj and Obj.valid and Obj.name:lower() == "yasuo_base_r_indicator_beam.troy" then
		self.KUP = self.KUP + 1
		print("Create: "..self.KUP)
	end
end

function Mid_Bundle_Yasuo:DeleteObj(Obj)
	if Obj and Obj.valid and Obj.name:lower() == "yasuo_base_r_indicator_beam.troy" then
		self.KUP = self.KUP - 1
		print("Delete: "..self.KUP)
	end
end

function Mid_Bundle_Yasuo:UpdateBuff(unit, buff)
	if unit.isMe then
		if buff.Name == "YasuoDashScalar" then
		    self.DashBuffCount = buff.Count
	    end
	end
end

function Mid_Bundle_Yasuo:RemoveBuff(unit, buff)
	if unit.isMe then
		if buff.Name == "YasuoDashScalar" then
		    self.DashBuffCount = 666
	    end
	end
end

function Mid_Bundle_Yasuo:SpellCast(spell)
	if spell.spellID == _Q then self.QT = GetTickCount() end
	if spell.spellID == _W then self.WT = GetTickCount() end
	if spell.spellID == _E then self.ET = GetTickCount() end
	if spell.spellID == _R then self.RT = GetTickCount() end
end

function Mid_Bundle_Yasuo:ProcessSpell(unit, spell)
    if unit.team ~= myHero.team then
            if Mid_Bundle_Spells[unit.charName] ~= nil then
                for _, skillshot in pairs(Mid_Bundle_Spells[unit.charName].skillshots) do
                    if skillshot.spellName == spell.name and skillshot.blockable == true then
                    	local range = skillshot.range
                        if not spell.startPos then
                            spell.startPos.x = unit.x
                            spell.startPos.z = unit.z                        
                        end                    
                        if GetDistance(spell.startPos) <= range then
                            if self.W.Ready then 
                                if  self.Menu.WindWall.Combo:Value() then
                        	        if Mode() == "Combo" then                        		      
                        		        if self.Menu.WindWall.SkillShots[skillshot.spellName].Block:Value() then
                        		        	if self.Menu.WindWall.Danger:Value() <= self.Menu.WindWall.SkillShots[skillshot.spellName].Danger:Value() then
                        		        		CastSkillShot(_W, unit.x, myHero.y, unit.z)
                        		        	end
                        		        end
                        	        end
                                else
                        	        if self.Menu.WindWall.SkillShots[skillshot.spellName].Block:Value() then
                        		        if self.Menu.WindWall.Danger:Value() <= self.Menu.WindWall.SkillShots[skillshot.spellName].Danger:Value() then
                        		        	CastSkillShot(_W, unit.x, myHero.y, unit.z)
                        		        end
                        		    end
                                end
                            end
                        end
                    end
                end
            end
        end
end

function Mid_Bundle_Yasuo:Draw()
    if IsDead(myHero) then return end

	local target = GetCurrentTarget()

	if self:MinionForGap(target) ~= nil then
		DrawCircle(self:DashEndPos(self:MinionForGap(target)), 35, 1, 1, GoS.Cyan)
	    DrawLine(WorldToScreen(0, GetOrigin(self:MinionForGap(target))).x, WorldToScreen(0, GetOrigin(self:MinionForGap(target))).y, WorldToScreen(0, self:DashEndPos(self:MinionForGap(target))).x, WorldToScreen(0, self:DashEndPos(self:MinionForGap(target))).y, 2, GoS.White)
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "Mid_Bundle_MinionManager"

function Mid_Bundle_MinionManager:__init()
	Minions = { All = {}, Enemy = {}, Ally = {}, Jungle = {} }

	Callback.Add("CreateObj", function(Obj) self:CreateObj(Obj) end)
	Callback.Add("ObjectLoad", function(Obj) self:CreateObj(Obj) end)
	Callback.Add("DeleteObj", function(Obj) self:DeleteObj(Obj) end)
end

function Mid_Bundle_MinionManager:CreateObj(Obj)
	if Obj.isMinion and not Obj.charName:find("Plant") and not Obj.dead then
		if Obj.charName:lower():find("minion") or Obj.team == MINION_JUNGLE then
			table.insert(Minions.All, Obj)
			if Obj.team == MINION_ALLY then
				table.insert(Minions.Ally, Obj)
			elseif Obj.team == MINION_ENEMY then
				table.insert(Minions.Enemy, Obj)
			elseif Obj.team == MINION_JUNGLE then
				table.insert(Minions.Jungle, Obj)
			end
		end
	end	
end

function Mid_Bundle_MinionManager:DeleteObj(Obj)
	if Obj.isMinion then
		for _, v in pairs(Minions.All) do
			if v == Obj then
				table.remove(Minions.All, _)
			end
		end
		
		if Obj.team == MINION_ENEMY then
			for _, v in pairs(Minions.Enemy) do
				if v == Obj then
					table.remove(Minions.Enemy, _)
				end
			end
		elseif Obj.team == MINION_JUNGLE then
			for _, v in pairs(Minions.Jungle, _) do
				if v == Obj then
					table.remove(Minions.Jungle, _)
				end
			end
		elseif Obj.team == MINION_ALLY then
			for _, v in pairs(Minions.Ally) do
				if v == Obj then
					table.remove(Minions.Ally, _)
				end
			end
		end		
	end	
end

Mid_Bundle_MinionManager()

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Mode()
    if IOW_Loaded then 
        return IOW:Mode()
    elseif DAC_Loaded then 
        return DAC:Mode()
    elseif PW_Loaded then 
        return PW:Mode()
    elseif GoSWalkLoaded and GoSWalk.CurrentMode then 
        return ({"Combo", "Harass", "LaneClear", "LastHit"})[GoSWalk.CurrentMode+1]
    elseif AutoCarry_Loaded then 
        return DACR:Mode()
    elseif _G.SLW_Loaded then 
        return SLW:Mode()
    elseif EOW_Loaded then 
        return EOW:Mode()
    end
    return ""
end

function GetLineFarmPos(range, width, table)
	local Pos, Hit = nil, 0
	for _, unit in pairs(table) do
		if ValidTarget(unit, range) then
			local count = CountObjectsOnLineSegment(Vector(myHero), Vector(unit), width, table, MINION_ENEMY)
			if not Pos or CountObjectsOnLineSegment(Vector(myHero), Vector(Pos), width, table, MINION_ENEMY) < count then
				Pos = Vector(unit)
				Hit = count
			end
		end
	end
	return Pos, Hit
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
