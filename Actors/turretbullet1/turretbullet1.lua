function BodyType()
	return 2
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	
	player = stage.player
	health = 10
	
	speed = 6
	
	
	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	--move specific/initialize animations--
	turretBullet1Set = actor:TileSetIndex( "turretbullet1.png" )
	

	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { turretBullet1Set, 0}
	end
	
	maxVelocity = ACTOR:b2Vec2()
	maxVelocity.x = math.random( 40, 40 )
	--maxVelocity.x = 15
	maxVelocity.y = maxVelocity.x
	
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
	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .5, .2, 0 ) 
	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .4, .1, 0 ) 
	actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .5, .2, 0 )
--	
  --actor:ClearHurtboxes()
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .5, .5, 0 ) 
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .5, .5, 0 ) 
	actor:SetFriction( 0 )
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .5, 1.5, 0 ) 
	SetAction( exist )
	
	if actor:IsFacingRight() then
		actor:SetVelocity( speed, 0 )
		
	else
		actor:SetVelocity( -speed, 0 )
		--actor:SetVelocity( speed, actor:GetVelocity().y )
	end
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
	
	ActionEnded()
	ChooseAction()
	HandleAction()
	
	
	
	end
	
	if slowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
		oldSlowFactor = slowFactor
		slowFactor = 1
	end
	
	
	
	actor:SetSprite( action[frame][1], action[frame][2] )
	--if slowFactor ~= 1 then
	--print( "frame: " .. frame )
	--print( "vel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
	--end
	--actor:SetSpriteAngle( angle ) 
	
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
	--if slowChange == 0 then
		--actor:SetVelocity( actor:GetVelocity().x * slowFactor, actor:GetVelocity().y * slowFactor )
		--print( "vel2: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
	--end
	--print( "surrounding Actors: " .. surroundingActors )
	
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
	actor:Kill()
	
	return hitboxStrings[hitboxTag], 10, 0, 0
	--return type, damage, hitlag, hitstun
end

--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, hitstun, hurtboxTag )
	--print( "hit by actor with hitboxName " .. hitboxName )
	--health = health - damage
	if health <= 0 then
		actor:Kill()
	end
	
	return false
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
	
	return false, false
	--enable then active
	--returns a bool for whether this should count or not
end

--not sure if this is necessary yet
function HandleActorCollision( posX, posY, otherActor )
end

function HandleStageCollision( pointCount, point1, point2, normal, enabled )
	actor:Kill()
	return enabled
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
	elseif msg == "walljump" then
		return 1
	elseif msg == "bouncejump" then
		return 1
	end
--actor/stage, string message, int tag
	--print( "message: " .. msg )
	return 0
end

function Die()
	
end
