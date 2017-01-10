local Config = MenuConfig("Flash", "Flash Draw")
Config:Boolean("range", "Draw Range")
Config:Boolean("circle", "Draw Circle")

OnDraw(function()
	local Flash_Pos = myHero.pos + (Vector(GetMousePos()) -  myHero.pos):normalized() * 475
	if Config.circle:Value() then DrawCircle(Flash_Pos, 75, 1, 1, GoS.White) end
	if Config.range:Value() then DrawCircle(GetOrigin(myHero), 475, 1, 1, GoS.White) end
end)
