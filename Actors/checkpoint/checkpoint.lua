function SpriteCount()
	return 1
end

function BodyType()
	return false, 0
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	print ( "init checkpoint" )
	player = stage.player
	health = 10
	--speed = .5--1
	active = false
	initializing = false
	alive = false
	
	
	
	
	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	spriteAngle = angle
	angle = spriteAngle * math.pi	
	
	--move specific/initialize animations--
	checkpointSet = actor:TileSetIndex( "checkpoint.png" )
	
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { checkpointSet, 0}
	end
	
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
	
	
	
	--this will eventually be replaced with createBoxes ONLY IN UPDATE for each action, if the box changes during a dash or w.e.
	--actor:ClearHurtboxes()
	--actor:CreateCircle( 12, Layer_PlayerDetection, 0, 0, 30 )
	
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .93, 1.56, 0 ) 
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .93, 1.56, 0 ) 
	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, 2, 2 , 0 )
	
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, 1 )
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .5 )
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .5 )
	--actor:CreateCircle( 11, Layer_ActorDetection, 0, 0, 1 )
	
	
	
	
  
--	actor:SetFriction( 0 )
	
	SetAction( exist )
	
	actor:SetSpriteEnabled( 0, true )
	actor:SetSpritePriority( 0, -3 )
	
	actor:SetSpriteAngle( 0, 0 )
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
	
	--actor:SetSpriteAngle( 0, actor:GetBodyAngle() )
	--actor:SetSprite( 0, action[frame][1], action[frame][2] )
end

function UpdatePostPhysics()
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
	health = health - damage
	--print( "runner health: " .. health )
	if health <= 0 then
		player:Message( actor, "checkpoint", 0 )
		actor:Kill()
	end
	
	return true
end

--when you collide with some Actor
function CollideWithActor( otherActor, tag )

	
	return false, true
	--enable then active
	--returns a bool for whether this should count or not
end

--not sure if this is necessary yet
function HandleActorCollision( posX, posY, otherActor )
end

function HandleStageCollision( pointCount, point1, point2, normal, enabled )
	enabled = false
	
	
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
--actor/stage, string message, int tag
	--print( "message: " .. msg )
	if msg == "activate" then
		initializing = true
	end
	
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
end

function LoadState()
	health = save_health
	slowCounter = save_slowCounter
	slowFactor = save_slowFactor
	oldSlowFactor = save_oldSlowFactor
	
	
end
