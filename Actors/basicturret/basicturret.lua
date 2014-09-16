function SpriteCount()
	return 1
end

function BodyType()
	return true, 0
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	--hitboxCenterX = 0
	print( "beginning" )
	player = stage.player
	
	actor:SetSpriteEnabled( 0, true )
	launch = true
	waitAfterFire = 1
	waitAfterFireCounter = 0
	currentBullet = nil
	spriteAngle = angle
	angle = spriteAngle * math.pi
	
	
	--move specific/initialize animations--

	--ringerSet = actor:TileSetIndex( "ringer.png" )
	basicTurretSet = actor:TileSetIndex( "basicturret.png" )
	local index = 0
	if maxBulletSize == .5 then
		index = 2
	elseif maxBulletSize == 1 then
		index = 1
	elseif maxBulletSize == 1.5 then
		index = 0
	else
		print( "error in max bullet size" )
	end
	active = {}
	for i = 1, 2 do
		active[i] = { basicTurretSet, index }
	end
	
	action = active
	frame = 1

	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Attack = 1}
	hitboxStrings = {"Attack"}
	
	--init state

	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, 1, 1.2, 0 )
	actor:CreateBox( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, 1, 1.2, 0 )
	
	--might have this in the update to grow each frame later
	--actor:ClearDetectionboxes()
	--actor:CreateCircle( 12, Layer_PlayerHitbox, 0, 0, 4 )
	
	--actor:CreateBox( 4, Layer_ActorDetection, .4 + .25, 0, .8, 1.5, 0 ) 
	local pos = ACTOR:b2Vec2()
	pos.x = actor:GetPosition().x + math.cos( angle ) * 0 + math.sin( angle ) * 1
	pos.y = actor:GetPosition().y + math.sin( angle) * 0 + math.cos( angle ) * -1
	
	local vel = ACTOR:b2Vec2()
	vel.x = 0
	vel.y = 0
	
	bulletArraySize = 16
	nextBulletIndex = 2
	--bulletArray = {}
	

	bulletActorGroup = stage:CreateActorGroup( "basicturretbullet", bulletArraySize, pos, vel, actor:IsFacingRight(), false, spriteAngle, actor )
	bulletActorGroup:Message( actor, "setmaxsize", maxBulletSize )

	for i = 0, bulletArraySize - 1 do
		bulletActorGroup:SetIndex( i )
		--bulletActorGroup:SetSpriteEnabled( 0, true )
		
		bulletActorGroup:SetPause( true )
	end
	bulletActorGroup:SetIndex( 0 )
	bulletActorGroup:SetPause( false )
	

	--bulletActorGroup:SetPause( true )
	
	--bulletArray[1]:SetPause( false )
	--baby = stage:CreateActor( "basicturretbullet", pos, vel, actor:IsFacingRight(), false, spriteAngle, actor )
	--baby:Message( actor, "setmaxsize", maxBulletSize )
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, -1.1, 4.2, 2.2, 0 )
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 1, 1.5, 3, 0 )
	--actor:SetVelocity( 0, 0 )
	--might have this in the update to grow each frame later
	--nextBulletIndex = 2
	--currentBullet = 1
	--currentBulletIndex = 1
	--actor:CreateCircle( 12, Layer_PlayerDetection, 0, 0, 1.17 )
	--actor:CreateCircle( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, .5 )
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, physicalRadius )
	
	--actor:CreateCircle( hitboxTypes.Slash, Layer_PlayerHitbox, 0, 0, .5, )
	actor:SetBodyAngle( angle )
	print( "-----------------------" )

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
	print( "s----" )
	ActionEnded()
	
	actor:ClearActorsAttacked()
	
	
	print( "s0" )
	if slowCounter == 0 then
		if launch then
			
			local available = GetNextBullet()
			
			if available then
				currentBullet = nextBulletIndex
				bulletActorGroup:SetIndex( nextBulletIndex - 1 )
				bulletActorGroup:SetPause( false )
				--bulletArray[nextBulletIndex]:SetPause( false )
				launch = false
				waitAfterFireCounter = 0
			end
		end
		
		if currentBullet > 0 then
			if waitAfterFireCounter < waitAfterFire then
				waitAfterFireCounter = waitAfterFireCounter + 1
			else
				bulletActorGroup:SetIndex( nextBulletIndex - 1 )
				--bulletActorGroup:SetPause( true )

			end
		end
	end
	
	print( "s1" )

	if slowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
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
		slowCounter = 0
	end

	
	if oldSlowFactor ~= 1 then
		
		actor:SetVelocity( actor:GetVelocity().x * oldSlowFactor, actor:GetVelocity().y * oldSlowFactor )
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
	
	
	return "",10 , 0, 0, 0
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
	elseif msg == "setmaxbulletsize" then
		maxBulletSize = tag
	elseif msg == "bulletlaunch" then
		launch = true
		
	end
	
	return 0
end

function Die()
	
end

function GetNextBullet()
	local found = false
	for i = 1, bulletArraySize do
		bulletActorGroup:SetIndex( nextBulletIndex - 1 )
		if not bulletActorGroup:IsPaused() then
			nextBulletIndex = nextBulletIndex + 1
			if nextBulletIndex > bulletArraySize then
				nextBulletIndex = 1
			end
		else
			found = true
			break
		end
	end
	return found
end

delayStartFrames = 0
maxBulletSize = 1

