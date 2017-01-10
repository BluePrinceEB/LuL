local Config = MenuConfig("Flash", "Flash Draw")
Config:Boolean("range", "Draw Range", true)
Config:Boolean("circle", "Draw Circle", true)

OnDraw(function()
	local Flash_Pos = myHero.pos + (Vector(GetMousePos()) -  myHero.pos):normalized() * 425
	if Config.circle:Value() then DrawCircle(Flash_Pos, 75, 1, 1, GoS.White) end
	if Config.range:Value() then DrawCircle(GetOrigin(myHero), 425, 1, 1, GoS.White) end
end)
