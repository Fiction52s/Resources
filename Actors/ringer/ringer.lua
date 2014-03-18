function SpriteCount()
	return 1
end

function BodyType()
	return 0
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	hitboxCenterX = 0
	player = stage.player
	touched = false
	speed = 7
	
	spriteAngle = angle
	angle = spriteAngle * math.pi
	maxVel = 3
	
	--move specific/initialize animations--

	ringerSet = actor:TileSetIndex( "ringer.png" )
	
	active = {}
	for i = 1, 2 do
		active[i] = { ringerSet, 0 }
	end
	actor:SetSpriteEnabled( 0, true )
	shockLength = 230
	shockFrame = 0
	
	action = active

	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Attack = 1}
	hitboxStrings = {"Attack"}
	
	--init state

	frame = 1
	
	--might have this in the update to grow each frame later
	--actor:ClearDetectionboxes()
	--actor:CreateCircle( 12, Layer_PlayerHitbox, 0, 0, 4 )
	
	--actor:CreateBox( 4, Layer_ActorDetection, .4 + .25, 0, .8, 1.5, 0 ) 

	actor:SetFriction( 0 )
	SetAction( active )
	currentHeight = 0
	startHeight = -.5
	highCount = 0
	speed = -.06
	maxHeight =  -3.5
	peakFrames = 25
	waitLength = 40
	waitFrame = 0
	
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, -1.1, 4.2, 2.2, 0 )
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 1, 1.5, 3, 0 )
	--actor:SetVelocity( 0, 0 )
	--might have this in the update to grow each frame later
	
	--actor:CreateCircle( 12, Layer_PlayerDetection, 0, 0, 1.17 )
	--actor:CreateCircle( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, .5 )
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, physicalRadius )
	
	--actor:CreateCircle( hitboxTypes.Slash, Layer_PlayerHitbox, 0, 0, .5, )
	
end

function GetAttackType( i )
	return hitTypes[i]
end

function Attack( otherActor )
	--print( "gotcha" )
	--print( "I am healing you" )
end

function ActionEnded()
	if frame > #action then 
		frame = 1
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
	
	ActionEnded()
	
	actor:ClearActorsAttacked()
	
	
	if slowCounter == 0 then
		if delayStartFrames > 0 then
			delayStartFrames = delayStartFrames - 1
		elseif currentHeight > maxHeight and speed < 0 then
			actor:ClearHitboxes()
			hitboxCenterX = -currentHeight * math.sin(angle)
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, -currentHeight * math.sin(angle), currentHeight * math.cos( angle ), .35 * ( 1 - currentHeight - maxHeight ), .7 , angle) 
			currentHeight = currentHeight + speed
			if currentHeight < maxHeight then
				currentHeight = maxHeight
			end
		elseif highCount <= peakFrames then
			highCount = highCount + 1
		elseif highCount > peakFrames and speed < 0 then
			speed = -speed
		elseif currentHeight < startHeight then
			actor:ClearHitboxes()
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, -currentHeight * math.sin(angle), currentHeight * math.cos( angle ), .35 * ( 1 - currentHeight - maxHeight ), .7 , angle )
			hitboxCenterX = -currentHeight * math.sin(angle)
			currentHeight = currentHeight + speed
			if currentHeight > startHeight then
				currentHeight = startHeight
				waitFrames = 0
			end
		elseif waitFrames <= waitLength then
			actor:ClearHitboxes()
			waitFrames = waitFrames + 1
			if waitFrames == waitLength then
				speed = -speed
				highCount = 0
			end
			--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, currentHeight, 1.5, .7 * ( 1 + currentHeight - maxHeight ), 0 ) 
		end

		--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, -3, .7, .7, 0 ) 
		--[[if currentHeight > maxHeight and speed < 0 then
			actor:ClearHitboxes()
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, currentHeight, 1.5, .7, 0 ) 
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, -.35, -2, 1, .9, 0 ) 
			currentHeight = currentHeight + speed
			
			if currentHeight < maxHeight then
				currentHeight = maxHeight 
			end
		elseif highCount == 0 then
			actor:ClearHitboxes()
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, -1.1, 4.2, 2.2, 0 )
			--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 1, 1.5, 3, 0 )
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, -.35, -2, 1, .9, 0 ) 
			highCount = highCount + 1
		elseif currentHeight == maxHeight and speed < 0 then			
			if highCount >= peakFrames then 
				speed = -speed
			end
			highCount = highCount + 1
		elseif currentHeight < startHeight then
			actor:ClearHitboxes()
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, currentHeight, 1.5, .7, 0 )
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, -.35, -2, 1, .9, 0 ) 	
			currentHeight = currentHeight + speed
			if currentHeight > startHeight then
				currentHeight = startHeight
				waitFrames = 0
			end
		elseif waitFrames <= waitLength then
			actor:ClearHitboxes()
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, -.35, -2, 1, .9, 0 ) 
			waitFrames = waitFrames + 1
			if waitFrames == waitLength then
				speed = -speed
				highCount = 0
			end
		end--]]
	end

	if slowFactor ~= 1 then
		--actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
		oldSlowFactor = slowFactor
		slowFactor = 1
	end
	
	--print( "Before" )
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
	actor:SetSpriteAngle( 0, spriteAngle )
end

function UpdatePostPhysics()
	slowCounter = slowCounter + 1
	if slowCounter >= slowFactor then
		frame = frame + 1
		shockFrame = shockFrame + 1
		slowCounter = 0
	end

	
	if oldSlowFactor ~= 1 then
		
		--actor:SetVelocity( actor:GetVelocity().x * oldSlowFactor, actor:GetVelocity().y * oldSlowFactor )
		--print( "oldchanging to: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
		oldSlowFactor = 1
	end

	--print( "crawler vel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
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
	
	
	return "",10 , 0, 0, hitboxCenterX
	--return hitboxStrings[hitboxTag], 10, 0, 0
	--return type, damage, hitlag, hitstun, centerX
end

function ConfirmHit( otheractor, hitboxName, damage, hitlag, xx )
	hitlagFrames = hitlag
	--actor:SetVelocity( 0, 0 )
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
	return false
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
		slowFactor = tag
		return 0
	elseif msg == "delaystartframes" then
		delayStartFrames = tag
		
		return 0
	end
	
	return 0
end

function Die()
	
end

delayStartFrames = 0
