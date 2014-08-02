function SpriteCount()
	return 1
end

function BodyType()
	return true, 1
	
	--false is fixed angle
	
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	player = stage.player
	
	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	spriteAngle = angle
	angle = spriteAngle * math.pi	
	
	--move specific/initialize animations--
	breakableTerrainSet = actor:TileSetIndex( "breakableterrain.png" )
	
	
	exist = {}
	--for i = 1, 2 do
	exist[1] = { breakableTerrainSet, 0}
	--end
	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Heal = 1, Slash = 2}
	hitboxStrings = {"Heal", "Slash"}
	
	--init state

	frame = 1
	
	originalPos = ACTOR:b2Vec2()
	originalPos.x = actor:GetPosition().x
	originalPos.y = actor:GetPosition().y
	
	
	
	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, 1, 1, 0 )
	actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsboxWithPlayer, 0, 0, 1, 1, 0 )

	
  
	actor:SetFriction( 0 )
	
	SetAction( exist )
	
	actor:SetSpriteEnabled( 0, true )
	actor:SetSpritePriority( 0, 4 )
	
	actor:SetSpriteAngle( 0, 0 )
	actor:SetSprite( 0, action[frame][1], action[frame][2] )	
	
	rcHit = false
	rcNormal = ACTOR:b2Vec2()
	leftEnabled = true
	rightEnabled = true
	upEnabled = true
	downEnabled = true
	
	hasChecked = false
	
	rayCastLength = .1
	
end

function GetAttackType( i )
	return hitTypes[i]
end

function Heal( otherActor )
	--print( "gotcha" )
	--print( "I am healing you" )
end

function Slash( otherActor )
	--print( "slashing" )
end

function ActionEnded()
	if frame > #action then 
		frame = 1
		--else
		--	action = nil
		--	frame = 0 --not sure if this ever comes into play
		--end
	end
end

function CancelAction()
	--here you would cancel any effects created by actions which are being canceled
end

function ChooseAction()
	--print( "srsly here guys" )
end

function HandleAction()

end

function UpdatePrePhysics()	
	if slowCounter == 0 then
		actionChanged = false
		actor:ClearActorsAttacked()
		
		ActionEnded()
		
		ChooseAction()
		HandleAction()
		
		
	end
	
	--leftEnabled = true
	--rightEnabled = true
	--upEnabled = true
	--downEnabled = true
	
	hasChecked = false
	
	if slowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
		oldSlowFactor = slowFactor
		slowFactor = 1
	end
	
	--actor:SetSpriteAngle( 0, 0 )
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
end

function UpdatePostPhysics()
	slowCounter = slowCounter + 1
	if slowCounter >= slowFactor then
		frame = frame + 1
		slowCounter = 0
	end

	if oldSlowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x * oldSlowFactor, actor:GetVelocity().y * oldSlowFactor )
		oldSlowFactor = 1
	end
end

function SetAction( newAction )
	if action ~= nil then
		CancelAction()
	end
	if action ~= newAction then
		actionChanged = true
	end
	action = newAction
end

--for when you hit something
function HitActor( otherActor, hitboxTag )
	if hitboxTag == hitboxTypes.Heal then
	--	print( "testing blah" )
	end 
	
	return hitboxStrings[hitboxTag], 10, 10, 0, 0
	--return type, damage, hitlag, hitstun
end

function ConfirmHit( otheractor, hitboxName, damage, hitlag, xx )
        --hitlagFrames = hitlag
        --actor:SetVelocity( 0, 0 )
end

--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, xhitstun, hurtboxTag, hitboxCenterX )
	--print( "hit by actor with hitboxName " .. hitboxName )
	--health = health - damage
	--print( "runner health: " .. health )
	--if health <= 0 then
	actor:Kill()
	--end
	
	return true
end

--when you collide with some Actor
function CollideWithActor( otherActor, tag, normal )
	if not hasChecked then
		hasChecked = true
	
		leftEnabled = true
		rightEnabled = true
		upEnabled = true
		downEnabled = true
	--right
		--Layer_EnemyPhysicsboxWithPlayer
		--actor:RayCast( actor:GetPosition().x + .5, actor:GetPosition().y - .4, actor:GetPosition().x + .5 + rayCastLength, actor:GetPosition().y - .4, Layer_Environment )
		local hit1 = false
		local hit2 = false
		
		--left--
		hit1 = false
		hit2 = false
		
		rcHit = false
		actor:RayCast( actor:GetPosition().x - .45, actor:GetPosition().y - .4, actor:GetPosition().x - .45 - rayCastLength, actor:GetPosition().y - .4, Layer_Environment )
		if rcHit and rcNormal.x == 1 then
			hit1 = true
		end
		
		rcHit = false
		actor:RayCast( actor:GetPosition().x - .45, actor:GetPosition().y + .4, actor:GetPosition().x - .45 - rayCastLength, actor:GetPosition().y + .4, Layer_Environment )
		if rcHit and rcNormal.x == 1 then
			hit2 = true
		end
		
		if hit1 and hit2 then
			leftEnabled = false
		end
		
		
		--right--
		hit1 = false
		hit2 = false
		
		rcHit = false
		actor:RayCast( actor:GetPosition().x + .45, actor:GetPosition().y - .4, actor:GetPosition().x + .45 + rayCastLength, actor:GetPosition().y - .4, Layer_Environment )
		if rcHit and rcNormal.x == -1 then
			hit1 = true
		end
		
		rcHit = false
		actor:RayCast( actor:GetPosition().x + .45, actor:GetPosition().y + .4, actor:GetPosition().x + .45 + rayCastLength, actor:GetPosition().y + .4, Layer_Environment )
		if rcHit and rcNormal.x == -1 then
			hit2 = true
		end
		
		if hit1 and hit2 then
			rightEnabled = false
		end
		
		--up--
		hit1 = false
		hit2 = false
		
		rcHit = false
		actor:RayCast( actor:GetPosition().x - .4, actor:GetPosition().y - .45, actor:GetPosition().x - .4, actor:GetPosition().y - .45 - rayCastLength, Layer_Environment )
		if rcHit and rcNormal.y == 1 then
			hit1 = true
		end
		
		rcHit = false
		actor:RayCast( actor:GetPosition().x + .4, actor:GetPosition().y - .45, actor:GetPosition().x + .4, actor:GetPosition().y - .45  - rayCastLength, Layer_Environment )
		if rcHit and rcNormal.y == 1 then
			hit2 = true
		end
		
		if hit1 and hit2 then
			upEnabled = false
		end
		
		--down--
		hit1 = false
		hit2 = false
		
		rcHit = false
		actor:RayCast( actor:GetPosition().x - .4, actor:GetPosition().y + .45, actor:GetPosition().x -.4, actor:GetPosition().y + .45 + rayCastLength, Layer_Environment )
		if rcHit and rcNormal.y == -1 then
			hit1 = true
		end
		
		rcHit = false
		actor:RayCast( actor:GetPosition().x + .4, actor:GetPosition().y + .45, actor:GetPosition().x + .4, actor:GetPosition().y + .45  + rayCastLength, Layer_Environment )
		if rcHit and rcNormal.y == -1 then
			hit2 = true
		end
		
		if hit1 and hit2 then
			downEnabled = false
		end
	end
	
	local enabled = false
	if normal.y < 0 then
		enabled = upEnabled
	elseif normal.y > 0 then
		enabled = downEnabled
	elseif normal.x > 0 then
		enabled = rightEnabled
	elseif normal.x < 0 then
		enabled = leftEnabled
	end
	
	--local bbbbb = "true"
	--if not enabled then
--		bbbbb = "false"
--	end
	
	--print( "normal: " .. normal.x .. ", " .. normal.y .. " ... enabled: " .. bbbbb )
	
	return enabled, true
	--return true, true
	--enable then active
	--returns a bool for whether this should count or not
end

--not sure if this is necessary yet
function HandleActorCollision( otherActor, hurtboxTag, pointCount, point1, point2, normal, enabled )
	
--	print( "normal: " .. normal.x .. ", " .. normal.y )
end

function HandleStageCollision( pointCount, point1, point2, normal, enabled )
	return enabled
end

function RayCastCallback( normalVec, point, fraction )
	rcNormal.x = normalVec.x
	rcNormal.y = normalVec.y
	rcHit = true
end

function Message( sender, msg, tag )
--actor/stage, string message, int tag
	--print( "message: " .. msg )
	return 0
end

function Die()
	
end

function SaveState()
	--note: 1 is the first index in Lua, not 0
	save_health = health
	save_slowCounter = slowCounter
	save_slowFactor = slowFactor
	save_oldSlowFactor = oldSlowFactor
	--save_spriteAngle = spriteAngle
	--save_angle = angle
	
	--save_action = action
	--save_frame = frame
	
	if framesToSwitch > 0 then
		save_accelx = accelx
		save_accely = accely
		save_frameCount = frameCount
		
	end
end

function LoadState()
	health = save_health
	slowCounter = save_slowCounter
	slowFactor = save_slowFactor
	oldSlowFactor = save_oldSlowFactor
	
	if framesToSwitch > 0 then
		accelx = save_accelx
		accely = save_accely
		frameCount = save_frameCount
		
	end
end