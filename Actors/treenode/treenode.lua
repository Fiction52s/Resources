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
	--note: 1 is the first index in Lua, not 0
		
	player = stage.player

	actorCount = actor:GetActorCount()
	
	--actor:SetSpriteEnabled( 0, true )
	
	--spriteAngle = angle
	spriteAngle = 0
	angle = 0
	--angle = spriteAngle * math.pi
	--originalPos = ACTOR:b2Vec2()
	--originalPos.x = actor:GetPosition().x
	--originalPos.y = actor:GetPosition().y
	
	
	--move specific/initialize animations--

	--local branchSet = actor:TileSetIndex( "treebranch.png" )
	local nodeSet = actor:TileSetIndex( "treenode.png" )
	
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Attack = 1}
	hitboxStrings = {"Attack"}
	
	active = {}
	for i = 1, 1 do
		active[i] = { nodeSet, 0 } --i-1
	end
	
	growthRate = .015
	minBranch = 5
	maxBranch = 10
	
	
	
	
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
	
	parentIndex = {}
	free = {}
	
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
		--actor:SetBodyAngle( angle )
		actor:SetSpriteEnabled( 0, true )
		
		--actor:CreateCircle( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, maxSize / 2 )
		--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, maxSize / 2 )
		actor:SetSprite( 0, nodeSet, 0 )
		actor:CreateCircle( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, 50/60 / 2 )
		
		parentIndex[i] = -1
		free[i] = false
	end
	
	for i = 2, actorCount do
		actor:SetIndex( i - 1 )
		actor:SetPause( true )
	end
	
	actor:SetSpritePriority( 0, 6 )
	
	free[1] = true
	
	--actor:SetSprite( 0, nodeSet, 0 )
	
	--contact types--
	actor:SetOrigin( actor:GetPosition().x, actor:GetPosition().y )
	--init state
	math.randomseed( os.time() )
	
	
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
		if not actor:IsPaused() and free[i] then
			local xp = actor:GetPosition().x
			local yp = actor:GetPosition().y
			
			for j = 1, actorCount do
				actor:SetIndex( j - 1 )
				if actor:IsPaused() then
					actor:SetPause( false )
					parentIndex[j] = i - 1
					local x = math.random() + 1
					local y = math.random() + 1
					
					
					
					actor:SetIndex( j - 1 )
					--if math.random() > .5 then
					if player:GetPosition().x < xp then
						x = -x
					end
					
					--if math.random() > .5 then
					if player:GetPosition().y < yp then
						y = -y
					end
					
					local xx = xp - player:GetPosition().x
					local yy = yp - player:GetPosition().y
					
					local ax = math.abs( xx )
					local ay = math.abs( yy )
					local d = xx * xx + yy * yy
					actor:SetPosition( xp, yp )
					actor:SetVelocity( xx / ( ax + ay ) * -2, yy / ( ax + ay ) * -2 )
					free[i] = false
					free[j] = false
					break
				end
			end
		end
	end
	
	for i = 1, actorCount do
		actor:SetIndex( i - 1 )
		
		if not actor:IsPaused() and (actor:GetVelocity().x ~= 0 or actor:GetVelocity().y ~= 0) then
			local x = actor:GetPosition().x
			local y = actor:GetPosition().y
			actor:SetIndex( parentIndex[i] )
			x = x - actor:GetPosition().x
			y = y - actor:GetPosition().y
			actor:SetIndex( i - 1 )
			local dist = x * x + y * y
			--print( "dist: " .. dist .. ", maxbranch: " .. maxBranch )
			local bad = false
			if dist >= minBranch then
				local xd = actor:GetPosition().x
				local yd = actor:GetPosition().y
				for j = 1, actorCount do
					actor:SetIndex( j - 1 )
					if i ~= j then
						local xxd = actor:GetPosition().x - xd
						local yyd = actor:GetPosition().y - yd
						local ddist = xxd * xxd + yyd * yyd
						if ddist <= 1 then
							bad = true
							break
						end
					end
				end
				actor:SetIndex( i - 1 )
				if not bad then
					actor:SetVelocity( 0, 0 )
					free[i] = true
					free[ parentIndex[i] + 1 ] = true
				end
			end
		end
	end
	
	for i = 1, actorCount do
		
	actor:SetIndex( i - 1 )
	if not actor:IsPaused() then
	
	ActionEnded()
	
	actor:ClearActorsAttacked()

	
	
	
	
	
	if slowCounter[i] == 0 then

	end
	
	if slowFactor[i] ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor[i], actor:GetVelocity().y / slowFactor[i] )
		oldSlowFactor[i] = slowFactor[i]
		slowFactor[i] = 1
	end
	
	--print( "Before" )
	--actor:SetSpriteScale( 0, size[i] / 1.25, size[i] / 1.25 )
	--actor:SetSprite( 0, action[i][frame[i]][1], action[i][frame[i]][2] )
	--actor:SetSpriteAngle( 0, actor.parent:GetBodyAngle() / math.pi * 180 )
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
	end

	
	if oldSlowFactor[i] ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x * oldSlowFactor[i], actor:GetVelocity().y * oldSlowFactor[i] )
		--print( "oldchanging to: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
		oldSlowFactor[i] = 1
	end

	
	end
	
	--actor:UpdateTrails()
	--print( "dfsihdsihdfsdfihsosiosfsd" )
	
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
		local i =  actor:GetIndex() + 1
		slowFactor[i] = tag
		return 0
	end
	
	return 0
end

function Die()
	
end
