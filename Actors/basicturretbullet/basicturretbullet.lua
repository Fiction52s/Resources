function SpriteCount()
	return 1
end

function BodyType()
	return true, 2
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
		
	player = stage.player

	actorCount = actor:GetActorCount()
	
	--actor:SetSpriteEnabled( 0, true )
	
	spriteAngle = angle
	angle = spriteAngle * math.pi
	originalPos = ACTOR:b2Vec2()
	originalPos.x = actor:GetPosition().x
	originalPos.y = actor:GetPosition().y
	
	
	--move specific/initialize animations--

	local redSet = actor:TileSetIndex( "redbullet.png" )
	local purpleSet = actor:TileSetIndex( "purplebullet.png" )
	local greenSet = actor:TileSetIndex( "greenbullet.png" )
	
	
	bulletSet = -1
	if maxSize == .5 then
		bulletSet = purpleSet
		speed = 16
	elseif maxSize == 1 then
		bulletSet = greenSet
		speed = 8
	elseif maxSize == 1.5 then 
		bulletSet = redSet
		speed = 4
	else
		print( "error with bullet type: " .. bulletSet .. ", maxsize: " .. maxSize )
	end
	
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Attack = 1}
	hitboxStrings = {"Attack"}
	
	active = {}
	for i = 1, 3 do
		active[i] = { bulletSet, 0 } --i-1
	end
	
	growthRate = .015
	
	
	size = {}
	action = {}
	frame = {}	--size bulletArraySize
	slowCounter = {}
	slowFactor = {}
	oldSlowFactor = {}
	launched = {}
	exploded = {}
	reset = {}
	actionChanged = {}
	hitlagFrames = {}
	
	
	
	for i = 1, actorCount do
		size[i] = .1
		action[i] = active
		frame[i] = 1
		slowCounter[i] = 0
		slowFactor[i] = 1
		oldSlowFactor[i] = 1
		launched[i] = false
		exploded[i] = false
		reset[i] = false
		actionChanged[i] = false
		hitlagFrames[i] = 0
		
		actor:SetIndex( i - 1 )
		actor:SetVelocity( 0, 0 )
		actor:SetBodyAngle( angle )
		--actor:SetSpriteEnabled( 0, false )
		
		actor:CreateCircle( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, maxSize / 2 )
		actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, maxSize / 2 )
		actor:CreateCircle( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, maxSize / 2 )
	end
	
	actor:SetSprite( 0, bulletSet, 0 )
	
	--contact types--
	
	
	--init state
	
	
	
end

function GetAttackType( i )
	return hitTypes[i]
end

function Attack( otherActor )
	--print( "gotcha" )
	--print( "I am healing you" )
end

function ActionEnded()
	for i = 1, actorCount do
		if frame[i] > #(action[i]) then 
			frame[i] = 1
		end
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
	--print( "Start" )
	for i = 1, actorCount do
		
	actor:SetIndex( i - 1 )
	if not actor:IsPaused() then
	
	ActionEnded()
	
	actor:ClearActorsAttacked()

	if reset[i] then
	--	hitlagFrames = hitlag
		
		
		exploded[i] = true
		actor:SetVelocity( 0, 0 )
		--actor:SetSprite( 0, bulletSet, 3 ) -- clear sprite
		actor:SetSpriteEnabled( 0, false )
		actor:SetPosition( originalPos.x, originalPos.y )
		size[i] = .1
		reset[i] = false
		actor:ClearTrail()
		--actor:ClearPhysicsboxes()
		--actor:ClearHitboxes()
		launched[i] = false
		actor:SetPause( true )
	else
	
	
	
	
	
	if slowCounter[i] == 0 then
		
		if size[i] <= maxSize and actor:GetVelocity().x == 0 and actor:GetVelocity().y == 0 then
			--actor:ClearHitboxes()
			--actor:CreateCircle( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, size / 2 )
			if size[i] == maxSize and not launched[i] then
				--actor:ClearPhysicsboxes()
				--actor:CreateCircle( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, size / 2 )
				--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, size / 2 )
				--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, size / 2 )
				
				actor.parent:Message( actor, "bulletlaunch", 0 )
				launched[i] = true
			end
		end
		
		if size[i] < maxSize then
			if size[i] + growthRate > maxSize then
				size[i] = maxSize
			else	
				size[i] = size[i] + growthRate
			end
		else
		--getbodyangle??
			--actor:SetVelocity( speed * math.sin( angle ), -speed * math.cos( angle ) )
		end
		
	

		
	end
	if slowFactor[i] ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor[i], actor:GetVelocity().y / slowFactor[i] )
		oldSlowFactor[i] = slowFactor[i]
		slowFactor[i] = 1
	end
	
	--print( "Before" )
	--actor:SetSpriteScale( 0, size[i] / 1.25, size[i] / 1.25 )
	actor:SetSprite( 0, action[i][frame[i]][1], action[i][frame[i]][2] )
	--actor:SetSpriteAngle( 0, actor.parent:GetBodyAngle() / math.pi * 180 )
	end
	
	end
	
	end
	--print( "End----------------" )
end

function UpdatePostPhysics()
	for i = 1, actorCount do
	
	actor:SetIndex( i - 1 )

	
	slowCounter[i] = slowCounter[i] + 1
	if slowCounter[i] >= slowFactor[i] then
		frame[i] = frame[i] + 1
		slowCounter[i] = 0
		actor:UpdateTrail()
	end

	
	if oldSlowFactor[i] ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x * oldSlowFactor[i], actor:GetVelocity().y * oldSlowFactor[i] )
		--print( "oldchanging to: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
		oldSlowFactor[i] = 1
	end

	
	end
	
	--actor:UpdateTrails()
	--print( "dfsihdsihdfsdfihsosiosfsd" )
	actor:SetOrigin( actor.parent:GetPosition().x, actor.parent:GetPosition().y )
	--collectgarbage()
	--print( "crawler vel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
end

function SetAction( newAction, index )
	if action[index] ~= nil then
		CancelAction()
	end
	if action[index] ~= newAction then
		actionChanged[index] = true
	end
	action[index] = newAction
end

--for when you hit something
function HitActor( otherActor, hitboxTag )
	return "",10 , 0, 0, 0
	--return hitboxStrings[hitboxTag], 10, 0, 0
	--return type, damage, hitlag, hitstun, centerX
end

function ConfirmHit( otheractor, hitboxName, damage, hitlag, xx )
	local i = actor:GetIndex()
	--if size[i] == maxSize then
		reset[i] = true
	--end
	hitlagFrames[i] = hitlag
	--explodes after hitlag
	
end

--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, hitstun, hurtboxTag )
	return false
end

--when you collide with some Actor
function CollideWithActor( otherActor, hurtboxTag )
	if hurtboxTag == 12 then
		--10
		touched = true
		
		--print( "slowFactor: " .. slowFactor )
	end
	
	return false, false
	--enable then active
	--returns a bool for whether this should count or not
end

--not sure if this is necessary yet
function HandleActorCollision( posX, posY, otherActor )
end

function HandleStageCollision( pointCount, point1, point2, normal, enabled )
	local i = actor:GetIndex() + 1
	reset[i] = true
	return true
end

function RayCastCallback( normalVec, point, fraction )
	rcFraction = fraction
	rcNormal.x = normalVec.x
	rcNormal.y = normalVec.y
	rcPoint.x = point.x
	rcPoint.y = point.y
	rcHit = true
end

function Message( sender, msg, tag )
--actor/stage, string message, int tag
	if msg == "slow" then
		local i =  actor:GetIndex() + 1
		slowFactor[i] = tag
		return 0
	elseif msg == "reactivate" then
		local i =  actor:GetIndex() + 1
		exploded[i] = false
		size[i] = .1
		action[i] = active
		frame[i] = 0
		
		
		return 0
	elseif msg == "setmaxsize" then
		maxSize = tag
	end
	
	return 0
end

function Die()
	
end

maxSize = 1
