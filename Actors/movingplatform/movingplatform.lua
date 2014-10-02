function SpriteCount()
	return 1
end

function BodyType()
	return true, 1
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	
	spriteAngle = angle
	angle = spriteAngle * math.pi	
	--print( "actor: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
	--note: 1 is the first index in Lua, not 0
	if framesToSwitch == 0 then
		framesToSwitch = 100
	end
	revolveSpeed = 0
	revolveRate = 0
	if revolveFrames > 0 then
		revolveSpeed = math.pi * revolveRadius * 2 / revolveFrames * 60 --timestep
		revolveRate = math.pi * 2 / revolveFrames
	elseif revolveFrames < 0 then
		revolveFrames = -revolveFrames
		revolveSpeed = -math.pi * revolveRadius * 2 / revolveFrames * 60 -- timestep
		revolveRate = -math.pi * 2 / revolveFrames
	end
	revolveAngle = revolveStartAngle
	frameCounter = -1
	surroundingActors = 0
	player = stage.player
	health = 20
	
	speed = ACTOR:b2Vec2()
	speed.x = actor:GetVelocity().x
	speed.y = actor:GetVelocity().y
	--existing = false
	--print( "initializing" )
	
	--move specific/initialize animations--
	movingPlatformSet = actor:TileSetIndex( "movingplatform.png" )
	
	actor:SetSpriteEnabled( 0, true )
	oldPos = ACTOR:b2Vec2()
	oldPos.x = actor:GetPosition().x
	oldPos.y = actor:GetPosition().y
	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { movingPlatformSet, 0}
	end
	
	actor:SetVelocity( distanceX * 60 / framesToSwitch, distanceY * 60 / framesToSwitch )
	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Heal = 1, Slash = 2}
	hitboxStrings = {"Heal", "Slash"}
	
	--init state

	frame = 1
	
	--actor:SetVelocity( 0, 0 )
	--this will eventually be replaced with createBoxes ONLY IN UPDATE for each action, if the box changes during a dash or w.e.
	--actor:ClearHurtboxes()
	--actor:CreateCircle( 12, Layer_PlayerDetection, 0, 0, 30 )
	local y = scaleY
	local x = scaleX
	actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsboxWithPlayer, 0, 0, x, y, 0 ) 
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsboxWithPlayer, -x / 2, 0, x / 4 )
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsboxWithPlayer, x / 2, 0, x / 4 )
	
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsboxWithPlayer, 0 , 0, x )
	actor:SetSpriteScale( 0,scaleX, scaleY )
	actor:SetBodyAngle( angle )
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, 2.1, 1, 0 ) 
		--actor:CreateCircle( 11, Layer_ActorDetection, 0, 0, 3 )
	--actor:SetVelocity( speed, speed )
--	
  --actor:ClearHurtboxes()
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .5, .5, 0 ) 
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .5, .5, 0 ) 
	actor:SetFriction( 0 )
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .5, 1.5, 0 ) 
	SetAction( exist )
	
	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	beforeRevolveVel = ACTOR:b2Vec2()
	beforeRevolveVel.x = 0
	beforeRevolveVel.y = 0
	
	stop = false
	stopCounter = 0
	stopFrames = 10
	
	actor:SetSpriteEnabled( 0, true )
	actor:SetSpritePriority( 0, -3 )
	actor:SetSpriteAngle( 0, actor:GetBodyAngle() )
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
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
	--spinFactor = 180
	if spinFactor ~= 0 then
		actor:SetBodyAngle( angle + math.pi / spinFactor )
		angle = angle + math.pi / spinFactor
		spriteAngle = angle / math.pi
	end
	--surroundingActors = 0
	--print( "updating" )
	--if initializing then
	--	actor:ClearDetectionboxes()
		--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .5, .5, 0 ) 
		--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .5, .5, 0 ) 
	--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, 2.1, 1, 0 ) 
		--actor:CreateCircle( 11, Layer_ActorDetection, 0, 0, 3 )
	--	actor:SetVelocity( speed, speed )
	--	initializing = false
	--	alive = true
	--end
	--actor:SetFriction( 1 )
	
	actionChanged = false
	
	ActionEnded()
	
	if slowCounter == 0 then
	
	ChooseAction()
	HandleAction()
	--print( "i swear im alive guys" )
	
	
	frameCounter = frameCounter + 1
	--print( "framecounter: " .. framesToSwitch )
	
	stopCounter = 0
	stopFrames = 10
	
	if frameCounter == framesToSwitch then
		stopCounter = 0
		frameCounter = 0
		actor:SetVelocity( -actor:GetVelocity().x, -actor:GetVelocity().y )
	end
	
	
	--
	--revolveRadius = 10
	--revolveRate = .5
	
	
	rs = math.sin( revolveAngle ) 
	rc = math.cos( revolveAngle )
	--actor:SetVelocity( vx * rs + vy * rc, vx * -rc + vy * -rs )
	beforeRevolveVel.x = actor:GetVelocity().x
	beforeRevolveVel.y = actor:GetVelocity().y
	actor:SetVelocity( actor:GetVelocity().x + (revolveSpeed * rc), actor:GetVelocity().y + (revolveSpeed * rs) )
	
	--revolveAngle = revolveAngle + revolveRate
	--print( "revolve angle: " .. revolveAngle )
	--print( "revolve rate: " .. revolveRate )
	
	
	end
	
	if slowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
		oldSlowFactor = slowFactor
		slowFactor = 1
	end
	
	actor:SetSprite( 0,action[frame][1], action[frame][2] )
	actor:SetSpriteAngle( 0,spriteAngle )
	surroundingActors = 0
	--print( "sprite angle: " .. spriteAngle )
end

function UpdatePostPhysics()
	slowCounter = slowCounter + 1
	if slowCounter >= slowFactor then
		frame = frame + 1
		--actor:SetVelocity( actor:GetVelocity().x - (rr * rc), actor:GetVelocity().y - (rr * rs) )
		actor:SetVelocity( beforeRevolveVel.x, beforeRevolveVel.y )
		--actor:SetVelocity( actor:GetVelocity().x - math.sin( revolveAngle ) * revolveRadius, actor:GetVelocity().y - math.cos( revolveAngle ) * revolveRadius )
		--actor:SetVelocity( vx - rs * rr , vx - rc * rr )
		revolveAngle = revolveAngle + revolveRate
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
	
	return hitboxStrings[hitboxTag], 10, 0, 0
	--return type, damage, hitlag, hitstun
end

--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, hitstun, hurtboxTag )
	--print( "hit by actor with hitboxName " .. hitboxName )
	health = health - damage
	if health <= 0 then
		actor:Kill()
	end
end

--when you collide with some Actor
function CollideWithActor( otherActor, tag )
	if tag == 12 then
		--print( "collide" )
		initializing = true
	elseif tag == 11 and otherActor.type ~= player.type then
		surroundingActors = surroundingActors + 1
		--print( "plus 1" )
	end
	--print( "collide" )
	
	return true, true
	--return true, true
	--enable then active
	--returns a bool for whether this should count or not
end

--not sure if this is necessary yet
function HandleActorCollision( otherActor, hurtboxTag, pointCount, point1, point2, normal, enabled )
end

function HandleStageCollision( pointCount, point1, point2, normal, enabled )
	return true
end

function RayCastCallback( normalVec, point, fraction )
	rcFraction = fraction
	rcNormal.x = normalVec.x
	rcNormal.y = normalVec.y
	rcPoint.x = point.x
	rcPoint.y = point.y

	rcCount = rcCount + 1
end

function Message( sender, msg, tag )
	if msg == "slow" then
		slowFactor = tag
		return 0
	end
	
	if msg == "stop" then
		
	elseif msg == "start" then
	
	end
	if msg == "playergrounded" and sender.type == player.type then
		--print( "send groundlock" )
		sender:Message( actor, "groundlock", 0 )
		return 0
		--sender:Message( actor, "carryx", 1 )
		--print( "groundlock" )
		--player:SetVelocity( player:GetVelocity().x + actor:GetVelocity().x, player:GetVelocity().y + actor:GetVelocity().y )
		--player:ApplyImpulse( 10, 0 )
	end
	if msg == "setframestoswitch" then
		framesToSwitch = tag
		return 0
	end
	if msg == "setscalex" then
		scaleX = tag
		return 0
	elseif msg == "setscaley" then
		scaleY = tag
		return 0
	elseif msg == "spinfactor" then
		spinFactor = tag
		return 0
	elseif msg == "revolveradius" then
		revolveRadius = tag
		return 0
	elseif msg == "revolveframes" then
		revolveFrames = tag
		return 0
	elseif msg == "revolvestartangle" then
		revolveStartAngle = tag / 180 * math.pi
		print( "Set start angle: " .. tag )
		return 0
		--print( "setting spinFactor to : " .. spinFactor )
	elseif msg == "distancex" then
		distanceX = tag
		return 0
	elseif msg == "distancey" then
		distanceY = tag
		return 0
	end
	return 0
end

function Die()
end
--before anything
framesToSwitch = 0
distanceX = 0
distanceY = 0
scaleX = 1
scaleY = 1
spinFactor = 0
revolveRadius = 0
revolveFrames = 0
revolveStartAngle = 0
