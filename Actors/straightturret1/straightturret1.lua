function BodyType()
	return 1
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	surroundingActors = 0
	player = stage.player
	health = 100
	shotSpeed = 60
	shotFrame = 1
	sightDistanceActive = 40
	sightDistanceNeutral = 9
	speed = math.max( math.min( math.random(), .5 ), .3 )
	active = false
	initializing = false
	alive = false
	--existing = false
	--print( "initializing" )
	
	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	--move specific/initialize animations--
	blueSquareSet = actor:TileSetIndex( "straightturret1.png" )
	
	oldPos = ACTOR:b2Vec2()
	oldPos.x = actor:GetPosition().x
	oldPos.y = actor:GetPosition().y
	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { blueSquareSet, 0}
	end
	
	maxVelocity = ACTOR:b2Vec2()
	maxVelocity.x = math.random( 10, 14 )
	--maxVelocity.x = 15
	maxVelocity.y = maxVelocity.x
	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Heal = 1, Slash = 2}
	hitboxStrings = {"Heal", "Slash"}
	
	--init state

	frame = 1
	
	actor:SetVelocity( 0, 0 )
	--this will eventually be replaced with createBoxes ONLY IN UPDATE for each action, if the box changes during a dash or w.e.
	--actor:ClearHurtboxes()
	actor:CreateCircle( 12, Layer_PlayerDetection, 0, 0, 30 )
	
--	
  --actor:ClearHurtboxes()
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .5, .5, 0 ) 
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .5, .5, 0 ) 
	actor:SetFriction( 0 )
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .5, 1.5, 0 ) 
	SetAction( exist )
	--actor:FaceLeft()
	--actor:FaceLeft()
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
	--surroundingActors = 0
	--print( "updating" )
	if initializing then
		actor:ClearDetectionboxes()
		actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .7, 1.3, 0 ) 
		
		--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .5, .5, 0 ) 
		--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, 1, 1, 0 ) 
		--actor:CreateCircle( 11, Layer_ActorDetection, 0, 0, 3 )
		initializing = false
		alive = true
	end
	
	if not alive then
		return
	end
	
	if slowCounter == 0 then
	
	shotFrame = shotFrame + 1
	if shotFrame >= shotSpeed then
		
		local aPos = ACTOR:b2Vec2()
		local aVel = ACTOR:b2Vec2()
		aVel.x = 0
		aVel.y = 0
		aPos.y = actor:GetPosition().y
		
		if actor:IsFacingRight() then
			aPos.x = actor:GetPosition().x + .5
		else
			aPos.x = actor:GetPosition().x - .5
		end
	
		stage:CreateActor( "turretbullet1", aPos, aVel, actor:IsFacingRight(), false, 0, actor )
		shotFrame = 1
	end
	
	actionChanged = false
	actor:ClearActorsAttacked()
	ActionEnded()
	ChooseAction()
	HandleAction()
	--print( "i swear im alive guys" )
	
	local dist = math.sqrt( math.pow(player:GetPosition().x - actor:GetPosition().x, 2) + math.pow( player:GetPosition().y - actor:GetPosition().y, 2 ) )
	
	if active then
		if dist > sightDistanceActive then
			active = false
			oldPos.x = actor:GetPosition().x
			oldPos.y = actor:GetPosition().y
		end
	else
		if dist <= sightDistanceNeutral then
			active = true
		end
	end
	
	--[[if active then
		if player:GetPosition().x > actor:GetPosition().x then
			actor:SetVelocity( actor:GetVelocity().x + speed, actor:GetVelocity().y )
		elseif player:GetPosition().x < actor:GetPosition().x then
			actor:SetVelocity( actor:GetVelocity().x - speed, actor:GetVelocity().y )
		end
		
		if player:GetPosition().y > actor:GetPosition().y then
			actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + speed )
		elseif player:GetPosition().y < actor:GetPosition().y then
			actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y - speed )
		end
	else
		if oldPos.x > actor:GetPosition().x then
			actor:SetVelocity( actor:GetVelocity().x + speed, actor:GetVelocity().y )
		elseif oldPos.x < actor:GetPosition().x then
			actor:SetVelocity( actor:GetVelocity().x - speed, actor:GetVelocity().y )
		end
		
		if oldPos.y > actor:GetPosition().y then
			actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + speed )
		elseif oldPos.y < actor:GetPosition().y then
			actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y - speed )
		end
	end--]]
	
--	actor:SetVelocity( 0, 0 )
	--max velocity checking
	if actor:GetVelocity().y > maxVelocity.y then
		actor:SetVelocity( actor:GetVelocity().x, maxVelocity.y )
	elseif actor:GetVelocity().y < -maxVelocity.y then
		actor:SetVelocity( actor:GetVelocity().x, -maxVelocity.y )
	end
	
	if actor:GetVelocity().x > maxVelocity.x then
		actor:SetVelocity( maxVelocity.x, actor:GetVelocity().y )
	elseif actor:GetVelocity().x < -maxVelocity.x then
		actor:SetVelocity( -maxVelocity.x, actor:GetVelocity().y )
	end
	
	if actor:GetVelocity().x > 0 then
		actor:FaceRight()
	elseif actor:GetVelocity().x < 0 then
		actor:FaceLeft()
	end
	
	end
	
	actor:SetSprite( action[frame][1], action[frame][2] )
	--actor:SetSpriteAngle( angle ) 
	
	if slowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
		oldSlowFactor = slowFactor
		slowFactor = 1
	end
	
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
		--surroundingActors = surroundingActors + 1
		--print( "plus 1" )
	end
	--print( "collide" )
	
	return false, true
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

	rcCount = rcCount + 1
end

function Message( sender, msg, tag )
--actor/stage, string message, int tag
	if msg == "slow" then
		slowFactor = tag
	end
	--print( "message: " .. msg )
	return 0
end

function Die()
	
end
