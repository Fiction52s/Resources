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
	actor:SetSpriteEnabled( 0, true )
	player = stage.player

	--actor:SetSpriteScale( 0, 2, 2 )
	--print( "initializing" )
	
	--move specific/initialize animations--
--	lobber1Set = actor:TileSetIndex( "lobber1.png" )
	landdustSet = actor:TileSetIndex( "landdust.png" )
	
	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 11 * 4 do
		exist[i] = { landdustSet, (i-1)/4 }
	end
	

	

	
	--init state

	frame = 1
	
	actor:SetVelocity( 0, 0 )
	--might have this in the update to grow each frame later
	--actor:ClearDetectionboxes()
	--actor:CreateCircle( 12, Layer_ActorDetection, 0, 0, 4 )

	--actor:SetFriction( 0 )
	SetAction( exist )
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
		actor:Kill()
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
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
end

function UpdatePostPhysics()
	--framesToLive = framesToLive - 1
	--if framesToLive == 0 then 
	--	actor:Kill()
	--end
	frame = frame + 1
	
	if frame > #action then
		actor:Kill()
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
	return 0, 0, 0, 0
	--return hitboxStrings[hitboxTag], 10, 0, 0
	--return type, damage, hitlag, hitstun
end

--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, hitstun, hurtboxTag )
end

--when you collide with some Actor
function CollideWithActor( otherActor, hurtboxTag )
	if hurtboxTag == 12 then
		--10
		otherActor:Message( actor, "slow", 8  )
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
end

function Message( sender, msg, tag )
--actor/stage, string message, int tag
	--print( "message: " .. msg )
	return 0
end

function Die()
	
end
