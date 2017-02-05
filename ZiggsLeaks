require("MapPositionGoS")

function OnTick()
	local target = Utility:Closest()
	if Utility:Mode() == "Combo" then
		if Utility:IsReady(_Q) and Utility:IsValidTarget(target, 1400, false, myHero.pos) then
			CastQ(target)
		end
	end
end

function OnDraw()
	local target = Utility:Closest()
	if target then
		local Prediction = target:GetPrediction(myHero:GetSpellData(_Q).speed, myHero:GetSpellData(_Q).delay)
		local CastPosition = mousePos
		if CastPosition then
			local Direction = (CastPosition - myHero.pos):Normalized()
			local FirstBounce = CastPosition
			local SecondBounce = FirstBounce + Direction * 0.4  * myHero.pos:DistanceTo(FirstBounce)
			local ThirdBounce = SecondBounce + Direction * 0.6 * FirstBounce:DistanceTo(SecondBounce)

			Draw.Circle(FirstBounce, 75, 2)
			Draw.Circle(SecondBounce, 75, 2, Draw.Color(255, 255, 0, 0))
			Draw.Circle(ThirdBounce, 75, 2, Draw.Color(255, 0, 0, 255))
		end 
	end
end

local Q1Range = 850
local Q2Range = 1125
local Q3Range = 1400

local Q1Delay = 0.3
local Q2Delay = Q1Delay + 0.25
local Q3Delay = Q2Delay + 0.3

function CastQ(target)
	local Prediction
	if myHero.pos:DistanceTo(target.pos) < Q1Range then
		Prediction = target:GetPrediction(myHero:GetSpellData(_Q).speed, Q1Delay)
	elseif myHero.pos:DistanceTo(target.pos) < Q2Range then
		Prediction = target:GetPrediction(myHero:GetSpellData(_Q).speed, Q2Delay)
	elseif myHero.pos:DistanceTo(target.pos) < Q3Range then
		Prediction = target:GetPrediction(myHero:GetSpellData(_Q).speed, Q3Delay)
	else 
		return 
	end

	if Prediction then
		if myHero.pos:DistanceTo(Prediction) <= Q1Range + 130 then
			local Point
			if myHero.pos:DistanceTo(Prediction) > 300 then
				Point = Prediction - 100 * (Prediction - myHero.pos):Normalized()
			else
				Point = Prediction
			end
			Utility:CastSpell(HK_Q, Point, Q3Range, 300)
		elseif myHero.pos:DistanceTo(Prediction) <= ((Q1Range + Q2Range)/2) then
			local Point = myHero.pos:Extend(Prediction, Q1Range - 100)
			if not QCollision(target, target.pos, Point) then
				Utility:CastSpell(HK_Q, Point, Q3Range, 300)
			end
		else
			local Point = myHero.pos + Q1Range * (Prediction - myHero.pos):Normalized()
			if not QCollision(target, target.pos, Point) then
				Utility:CastSpell(HK_Q, Point, Q3Range, 300)
			end
		end
	end
end

function QCollision(target, pos)
	local Direction = (pos - myHero.pos):Normalized()
	local FirstBounce = pos
	local SecondBounce = FirstBounce + Direction * 0.4  * myHero.pos:DistanceTo(FirstBounce)
	local ThirdBounce = SecondBounce + Direction * 0.6 * FirstBounce:DistanceTo(SecondBounce)

	if MapPosition:inWall(FirstBounce) then
		return true
	end

	if ThirdBounce:DistanceTo(target.pos) < 130 + target.boundingRadius then
		for key, minion in pairs(Utility:GetEnemyMinions()) do
			local Prediction = minion:GetPrediction(myHero:GetSpellData(_Q).speed, Q3Delay)
			if Prediction and Prediction:DistanceTo(FirstBounce) < 130 + minion.boundingRadius then
				return true
			end
		end
	end

	if SecondBounce:DistanceTo(target.pos) < 130 + target.boundingRadius or ThirdBounce:DistanceTo(target.pos) < 130 + target.boundingRadius then
		for key, minion in pairs(Utility:GetEnemyMinions()) do
			local Prediction = minion:GetPrediction(myHero:GetSpellData(_Q).speed, Q1Delay)
			if Prediction and Prediction:DistanceTo(FirstBounce) < 130 + minion.boundingRadius then
				return true
			end
		end
	end
	return false
end

class "Utility"

castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
function Utility:CastSpell(spell,pos,range,delay)
local delay = delay or 250
local ticker = GetTickCount()
	if castSpell.state == 0 and myHero.pos:DistanceTo(pos) < range and ticker - castSpell.casting > delay + Game.Latency()then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < Game.Latency() then
			Control.SetCursorPos(pos)
			Control.KeyDown(spell)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end,Game.Latency()/1000)
		end
		if ticker - castSpell.casting > Game.Latency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end

function Utility:Mode()
	if EOWLoaded then
		return EOW:Mode()
	else
		if Orbwalker["Combo"].__active then
		    return "Combo"
	    elseif Orbwalker["Farm"].__active then
		    return "LaneClear" 
	    elseif Orbwalker["LastHit"].__active then
		    return "LastHit"
	    elseif Orbwalker["Harass"].__active then
		    return "Harass"
	    end
	    return ""
	end
end

function Utility:Closest()
	local c = math.huge
	local t = nil
	for _, e in pairs(Utility:GetEnemyHeroes()) do
		if e.distance < c then
			c = e.distance
			t = e
		end
	end
	return t
end

function Utility:ClosestM()
	local c = math.huge
	local t = nil
	for _, e in pairs(Utility:GetEnemyHeroes()) do
		if e.pos:DistanceTo(mousePos) < c then
			c = e.pos:DistanceTo(mousePos)
			t = e
		end
	end
	return t
end

function Utility:HighestAD()
	local c = 0
	local t = nil
	for _, e in pairs(Utility:GetEnemyHeroes()) do
		if e.totalDamage > c then
			c = e.totalDamage
			t = e 
		end
	end
	return t
end

function Utility:HighestAP()
	local c = 0
	local t = nil
	for _, e in pairs(Utility:GetEnemyHeroes()) do
		if e.ap > c then
			c = e.ap
			t = e
		end
	end		
end

function Utility:HighestHP()
	local c = 0
	local t = nil
	for _, e in pairs(Utility:GetEnemyHeroes()) do 
		if e.health > c then
			c = e.health
			t = e 
		end
	end
	return t
end

function Utility:LowestHP()
	local c = math.huge
	local t = nil
	for _, e in pairs(Utility:GetEnemyHeroes()) do 
		if e.health < c then
			c = e.health
			t = e
		end
	end
	return t
end

function Utility:GetPercentHP(unit)
	return 100 * unit.health / unit.maxHealth
end

function Utility:GetPercentMP(unit)
	return 100 * unit.mana / unit.maxMana
end

function Utility:GetEnemyHeroes()
	self.EnemyHeroes = {}
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isEnemy then
			table.insert(self.EnemyHeroes, Hero)
		end
	end
	return self.EnemyHeroes
end

function Utility:GetEnemyMinions()
	self.EnemyMinions = {}
	for i = 1, Game.MinionCount() do
		local Minion = Game.Minion(i)
		if Minion.isEnemy then
			table.insert(self.EnemyMinions, Minion)
		end
	end
	return self.EnemyMinions
end

function Utility:GetAllyHeroes()
	self.AllyHeroes = {}
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isAlly and not Hero.isMe then
			table.insert(self.AllyHeroes, Hero)
		end
	end
	return self.AllyHeroes
end

function Utility:GetBuffs(unit)
	self.T = {}
	for i = 0, unit.buffCount do
		local Buff = unit:GetBuff(i)
		if Buff.count > 0 then
			table.insert(self.T, Buff)
		end
	end
	return self.T
end

function Utility:HasBuff(unit, buffname)
	for K, Buff in pairs(self:GetBuffs(unit)) do
		if Buff.name:lower() == buffname:lower() then
			return true
		end
	end
	return false
end

function Utility:GetBuffData(unit, buffname)
	for i = 0, unit.buffCount do
		local Buff = unit:GetBuff(i)
		if Buff.name:lower() == buffname:lower() and Buff.count > 0 then
			return Buff
		end
	end
	return {type = 0, name = "", startTime = 0, expireTime = 0, duration = 0, stacks = 0, count = 0}
end

function Utility:IsImmune(unit)
	for K, Buff in pairs(self:GetBuffs(unit)) do
		if (Buff.name == "kindredrnodeathbuff" or Buff.name == "undyingrage") and self:GetPercentHP(unit) <= 10 then
			return true
		end
		if Buff.name == "vladimirsanguinepool" or Buff.name == "judicatorintervention" then 
            return true
        end
	end
	return false
end

function Utility:IsValidTarget(unit, range, checkTeam, from)
    local range = range == nil and math.huge or range
    if unit == nil or not unit.valid or not unit.visible or unit.dead or not unit.isTargetable or self:IsImmune(unit) or (checkTeam and unit.isAlly) then 
        return false 
    end 
    return unit.pos:DistanceTo(from and from or myHero) < range 
end

function Utility:IsReady(slot)
	if myHero:GetSpellData(slot).currentCd < 0.01 and myHero.mana > myHero:GetSpellData(slot).mana then
		return true
	end
	return false
end

function Utility:IsReady2(slot)
	if myHero:GetSpellData(slot).currentCd < 0.01 then
		return true
	end
	return false
end

function Utility:ImOk()
	for i = 0, myHero.buffCount do
		local buff = myHero:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 ) and buff.count > 0 then
			return false
		end
	end
	return true
end

function OnLoad()
	if _G[myHero.charName] then _G[myHero.charName]() end
end
