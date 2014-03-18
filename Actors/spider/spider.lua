function SpriteCount()
	return 2
end

function BodyType()
	return true, 2
	
	--fixed rotation,
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	--hitboxCenterX = 0
	player = stage.player
	
	spriteAngle = angle
	angle = spriteAngle * math.pi
	
	jumpX = 0
	rcFraction = 0
	rcNormal = ACTOR:b2Vec2()
	rcPoint = ACTOR:b2Vec2()
	rcNormal.x = 0
	rcNormal.y = 0
	rcPoint.x = 0
	rcPoint.y = 0
	rcHit = false
	rcCount = 0
	laserAngle = 0
	hurt = false
	goingOverCorner = false
	instantJump = false
	--move specific/initialize animations--
	activated = false
	--ringerSet = actor:TileSetIndex( "ringer.png" )
	spiderSet = actor:TileSetIndex( "spider.png" )
	laserSet = actor:TileSetIndex( "laser.png" )
	grounded = false
	lastGrounded = false
	trueGrounded = false
	actionChanged = false
	touchingLeftWall = false
	touchingRightWall = false
	wallThreshold = .9
	bulletGrav = .5 + math.random()
	prevAction = nil
	xDiff = 0
	yDiff = 0
	onWall = false
	chasing = false
	switchCounter = 0
	switchLimit = 3
	actor:SetSpriteEnabled( 0, true )
	
	idle = {}
	for i = 1, 30 do
		idle[i] = {spiderSet, 0}
	end
	
	root = {}
	for i = 1, 30 do
		root[i] = {spiderSet, 0}
	end
	
	fire = {}
	laserFire = {}
	for i = 1, 120 do
		fire[i] = {spiderSet, 0}
		if i < 60 then
			laserFire[i] = { laserSet, i / 6 }
		elseif i < 80 then
			laserFire[i] = { laserSet, 9 + i % 3 }
		elseif i < 100 then
			laserFire[i] = {laserSet, ( 100 - i ) / 2 }
		end
		--laserFire[i] = {laserSet, 11 }
	end
	
	unroot = {}
	for i = 1, 30 do
		unroot[i] = {spiderSet, 0}
	end

	
	run = {}
	for i = 1, 5 do
		run[i] = {spiderSet, 0}
	end
	lobRate = 15
	lobCounter = 0
	
	jump = {}
	for i = 1, 12 do
		jump[i] = {spiderSet, 0}
	end
	
	rushPrepare = {}
	for i = 1, 20 do
		rushPrepare[i] = {spiderSet, 0}
	end
	
	rush = {}
	for i = 1, 5 do
		rush[i] = {spiderSet, 0}
	end
	
	turn = {}
	for i = 1, 20 do
		turn[i] = {spiderSet, 0}
	end
	
	lob = {}
	for i = 1, 10 do
		lob[i] = {spiderSet, 0}
	end
	
	wallIdle = {}
	for i = 1, 30 do
		wallIdle[i] = {spiderSet, 0}
	end
	
	physicalRadius = .4
	hit = false
	norm = ACTOR:b2Vec2()
	norm.x = 0
	norm.y = 0
	
	changed = false
	
	groundNormal = ACTOR:b2Vec2()
	groundNormal.x = 0
	groundNormal.y = -1
	
	
	oldGroundNormal = ACTOR:b2Vec2()
	oldGroundNormal.x = 0
	oldGroundNormal.y = -1
	
	prevVelocity = ACTOR:b2Vec2()
	prevVelocity.x = 0
	prevVelocity.y = 0

	activationRange = 40
	activationRangeSqr = activationRange^2
	forfRange = 10--8--6
	forfRangeSqr = forfRange^2
	chaseRange = 30
	chaseRangeSqr = chaseRange^2
	
	fireRange = 15 + math.random( 5 )--18--20 - math.random( 5 )
	fireRangeSqr = fireRange^2
	fireHitboxLength = 100
	framesInAir = 0
	canMoveFarther = false
	laserHitboxRange = 100
	
	action = jump
	frame = #action

	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	--contact types--
	bodyTypes = {Normal = 1, Test = 2}
	bodyStrings = {"Normal"}
	hitboxTypes = {Attack = 1}
	hitboxStrings = {"Attack"}
	
	--init state
	actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, physicalRadius )
	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .7, .82, 0 )
	actor:CreateBox( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, .7, .82, 0 )
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .7, .82, 0 )
	
	jumpStrength = ACTOR:b2Vec2()
	jumpStrength.x = 8 --+ math.random( 4 )
	jumpStrength.y = 12 --+ math.random( 7 )
	runSpeed = 7 --+ math.random( 3 )
	rushSpeed = 15 --+ math.random( 5 )
	
	lobStrength = ACTOR:b2Vec2()
	lobStrength.x = 5 --+ math.random( 4 )
	lobStrength.y = 12 --+ math.random( 10 )
	--actor:SetVelocity( -4, 0 )
	--might have this in the update to grow each frame later
	--actor:ClearDetectionboxes()
	--actor:CreateCircle( 12, Layer_PlayerHitbox, 0, 0, 4 )
	
	--actor:CreateBox( 4, Layer_ActorDetection, .4 + .25, 0, .8, 1.5, 0 ) 
	playerDistSqr = 0
	
	centerOffsetX = 0
	playerWidth = .35
	playerHeight = .41
	--actor:SetVelocity( 0, runSpeed )
	
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
	actor:SetSpriteAngle( 0, spriteAngle )
	actor:SetBodyAngle( angle )
	
	checkCloser = false
	setrun = false
	stopped = false
	--actor:FaceLeft()
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
		if action == run then
			--frame = 1 
			
			frame = 1
		elseif action == idle then
			--SetAction( run )
			frame = 1
			--actor:SetVelocity( runSpeed * norm.y, runSpeed * -norm.x )
			--if hit then
			--print( "CHANGED" )
			--end
		elseif action == root then
			SetAction( fire )
			frame = 1
		elseif action == jump then
			frame = #action
		elseif action == unroot then
			SetAction( idle )
			frame = 1
		elseif action == fire then
			frame = 1
		end
	end
end

function CancelAction()
	--here you would cancel any effects created by actions which are being canceled
end

function ChooseAction()
	
	if action == jump and grounded then
		actor:SetVelocity( 0, 0 )
		if instantJump then
			
			--print( "instantjump" )
			SetAction( jump )
			frame = 1 
			framesInAir = 0
			grounded = false
		else
			SetAction( idle )
			frame = 1
		end
		
	end
	
	if playerDistSqr < forfRangeSqr then
		--print( "f or f range" )
		if action == run then
			if not canMoveFarther or chasing then--or switchCounter > switchLimit then
				chasing = false
				SetAction( jump )
				frame = 1
				--if switchCounter > switchLimit then
					
				switchCounter = 0
				
				--print( "normal jump" )
				
				--SetAction( run )
				--frame = 1
			end
		end
		if action == idle or ( action == fire and frame == 1 ) then
			SetAction( run )
			frame = 1
			setrun = true
			--print( "setting run" )
		end
	elseif playerDistSqr < fireRangeSqr then
		--print( "fire range" )
		if action == run or action == idle then
			--print( "frame: " .. frame )
			local halfRangeSqr = ( ( forfRange + fireRange ) / 2 )^2
			if playerDistSqr > halfRangeSqr then
				if chasing then chasing = false end
				SetAction( root )
				frame = 1
			else
				if chasing then
					SetAction( root ) 
					frame = 1
					chasing = false
				else
					if not canMoveFarther then
						SetAction( root )
						frame = 1
					end
				end
			end	
		end
	elseif playerDistSqr < chaseRangeSqr then
		--print( "idle range" )
		if action ~= idle and action ~= fire and action ~= root and action ~= unroot and action ~= jump and action ~= run then
			SetAction( idle )
			frame = 1
			actor:SetVelocity( 0, 0 )
		end
		
		if action == run then
			if not canMoveFarther or stopped then
				chasing = false
			--	print( "other jump " )
				SetAction( jump )
				frame = 1
				switchCounter = 0
			end
		end
		
		if action == idle then
			SetAction( run )
			frame = 1
			chasing = true
			setrun = true
		end
		
		
		
		if action == fire and frame == 1 then
			SetAction( unroot )
		end
	elseif playerDistSqr < activationRangeSqr then
		--print( "farthest range" )
		if action ~= idle and action ~= fire and action ~= root and action ~= unroot and action ~= jump then
			SetAction( idle )
			frame = 1
			actor:SetVelocity( 0, 0 )
		end
		if action == idle then
			SetAction( run )
			frame = 1
			chasing = true
		end
		if action == fire and frame == 1 then
			SetAction( unroot )
		end
	else
		--deactivate
		if action ~= jump then
			SetAction( idle )
			frame = 1
		end
		
		if action == idle then
			activated = false
		end
		--this will eventually have it chase you
	end	
	--print( "frame: " .. frame )
	--if action == idle and frame == 20 then
		
	
	--if math.abs( xDiff ) > 3 and action == idle then
	--	SetAction( run )
	--	frame = 1
	--	if actor:IsFacingRight() then
	--		actor:SetVelocity( runSpeed * -norm.y, runSpeed * norm.x )
	--	else
	--		actor:SetVelocity( runSpeed * norm.y, runSpeed * -norm.x )
	--	end
		--SetAction( idle ) 
		--frame = 1
	--elseif math.abs( xDiff ) <= 3 and action == run then
	--	SetAction( idle )
	--	frame = 1
	--	actor:SetVelocity( 0, 0 )
	--end
	if math.abs( xDiff ) <= 3 and action == idle and frame == 20 then
		--SetAction( run )
		--frame = 1
		--print( "set: " .. runSpeed * norm.y .. ", " .. runSpeed * -norm.x )
		--actor:SetVelocity( runSpeed * norm.y, runSpeed * -norm.x )
	end
	--if math.abs(xDiff) < 3 and action ~= run then
	--	SetAction( run )
--		frame = 1
--		actor:SetVelocity( runSpeed * norm.y, runSpeed * norm.x )
--	elseif math.abs( xDiff ) >= 3 and action ~= idle then
--		SetAction( idle )
--		frame = 1
--		actor:SetVelocity( 0, 0 )
--	end
end

function HandleAction()
	if action == idle or action == root or action == unroot then
		actor:SetVelocity( 0, 0 )
	end
	
	if (action == run or action == jump) and playerDistSqr < chaseRangeSqr and playerDistSqr >= fireRangeSqr then
		chasing = true
	end

	
	--if playerDistSqr < chaseRangeSqr and playerDistSqr >= fireRangeSqr then
	--	print( "chasing is true" )
	--else
	--	print( "CHASING IS FALSE: " .. playerDistSqr )
	--end
	
	if action == run and not setrun then
		local startx = actor:GetPosition().x - norm.x * (physicalRadius + .5)
		local starty = actor:GetPosition().y - norm.y * (physicalRadius + .5)
		local dirx = -actor:GetVelocity().x / math.abs(runSpeed) * 1
		local diry = -actor:GetVelocity().y / math.abs(runSpeed) * 1
		rcHit = false
		if norm.x ~= 0 or norm.y ~= 0 then
			local dirx2 = -norm.x * (physicalRadius + .5)
			local diry2 = -norm.y * (physicalRadius + .5)
			actor:RayCast( actor:GetPosition().x, actor:GetPosition().y, actor:GetPosition().x + dirx2, 
			actor:GetPosition().y + diry2, Layer_Environment )
			
			if rcHit then 
				--print( "before pos: " .. actor:GetPosition().x .. ", " .. actor:GetPosition().y .. ", after: " .. rcPoint.x + physicalRadius * norm.x .. ", " .. rcPoint.y + physicalRadius * norm.y )
				actor:SetPosition( rcPoint.x + physicalRadius * norm.x, rcPoint.y + physicalRadius * norm.y)
				--print( "setpos: " )
			end
			if not rcHit then
				actor:RayCast( startx, starty, startx + dirx, starty + diry, Layer_Environment )
			end
		end
		
		if not chasing then
			lobCounter = lobCounter + 1
			if lobCounter >= lobRate then
				lobCounter = 0
				local aPos = actor:GetPosition()
				aPos.x = aPos.x + math.sin( angle ) * .5
				aPos.y = aPos.y + math.cos( angle ) * -.5
				local aVel = ACTOR:b2Vec2()
				--lobStrength.x = 0
				aVel.x = math.cos( -angle ) * lobStrength.x + math.sin( -angle ) * -lobStrength.y
				aVel.y = math.sin( -angle ) * lobStrength.x + math.cos( -angle ) * -lobStrength.y - 5
				if actor:IsFacingRight() then
					aVel.x = math.cos( -angle  ) * -lobStrength.x + math.sin( -angle ) * -lobStrength.y
					aVel.y = math.sin( -angle  ) * -lobStrength.x + math.cos( -angle ) * -lobStrength.y - 5
				end
				--print( "pos: " .. aPos.x .. ", " .. aPos.y )
				--print( "vel: " .. aVel.x .. ", " .. aVel.y )
				--print( "angle: " .. -angle )
				
				--aVel.x = aVel.x + xDiff / 2
				--aVel.x = xDiff
				--aVel.y = yDiff - 10
				
				bullet = stage:CreateActor( "lobberbullet1", aPos, aVel, actor:IsFacingRight(), false, 0, actor )
				bullet:Message( actor, "setgrav", bulletGrav )
			end
		end
	end
	
	if action == run and setrun then
		if actor:IsFacingRight() then
			actor:SetVelocity( runSpeed * -norm.y, runSpeed * norm.x )
		else
			actor:SetVelocity( norm.y * runSpeed, -norm.x * runSpeed )
		end
	end
	
	if action == fire then
		
	end
	
	if action == jump and frame == 1 then
		jumpStrength.y = 20
		local jsy = jumpStrength.y
		jumpStrength.x = 10
		
		if math.random() < .5 then
			--actor:FaceRight() 
		else
			--actor:FaceLeft()
		end
		--for chasing only ------------------------------------------------------------
		
	
		
		local angleBetween = math.atan2( -xDiff, -yDiff )
		angleBetween = -angleBetween
		
		local testAngle = angleBetween - angle
		--if testAngle < 0 then testAngle = testAngle + math.pi * 2 end
		--if testAngle > math.pi * 2 then testAngle = testAngle - math.pi * 2 end
		if instantJump then
			actor:SetVelocity( math.sin( -angle ) * -15, math.cos( -angle ) * -15 )
			instantJump = false
		elseif chasing then
			if math.abs(testAngle) < .1 then
				if xDiff > 0 then
					actor:SetVelocity( xDiff + 4, -15 + yDiff )
				elseif xDiff < 0 then
					actor:SetVelocity( xDiff - 4, -15 + yDiff )
				end
			elseif math.abs(math.abs(testAngle) - math.pi) < .1  then
				if xDiff > 0 then
					actor:SetVelocity( xDiff + 4, -15 + yDiff )
				elseif xDiff < 0 then
					actor:SetVelocity( xDiff - 4, -15 + yDiff )
				end
			elseif norm.y > 0 then
				if xDiff > 0 then
					actor:SetVelocity( xDiff + 8, 0 )
				elseif xDiff < 0 then
					actor:SetVelocity( xDiff - 8, 0 )
				end
			else
				if xDiff > 0 then
					actor:SetVelocity( xDiff / 2, -15 + yDiff )
				elseif xDiff < 0 then
					actor:SetVelocity( xDiff / 2, -15 + yDiff )
				end
				
				
				
				--if yDiff > 0 then
				--elseif yDiff < 0 then
				--end
			end
		elseif not chasing then
			--print( "not chasing" )
			if math.abs(testAngle) < .1 then
				if xDiff > 0 then
					actor:SetVelocity( -10, -15 - yDiff )
				elseif xDiff < 0 then
					actor:SetVelocity( 10, -15 - yDiff )
				end
			elseif math.abs(math.abs(testAngle) - math.pi) < .1  then
				if xDiff > 0 then
					actor:SetVelocity( -10, -15 - yDiff )
				elseif xDiff < 0 then
					actor:SetVelocity( 10, -15 - yDiff )
				end
			elseif norm.y > 0 then
				if xDiff > 0 then
					actor:SetVelocity( -10, 0 )
				elseif xDiff < 0 then
					actor:SetVelocity( 10, 0 )
				end
			else
				if xDiff > 0 then
					actor:SetVelocity( -10, -15 - yDiff )
				elseif xDiff < 0 then
					actor:SetVelocity( 10, -15 - yDiff )
				end
			end
		end
		
		if actor:GetVelocity().x > 15 then
			actor:SetVelocity( 15, actor:GetVelocity().y )
		elseif actor:GetVelocity().x < -15 then
			actor:SetVelocity( -15, actor:GetVelocity().y )
		end
		
		if actor:GetVelocity().y > 20 then
			actor:SetVelocity( actor:GetVelocity().x, 20 )
		elseif actor:GetVelocity().y < -20 then
			actor:SetVelocity( actor:GetVelocity().x, -20 )
		end
		
		jumpX = actor:GetVelocity().x
		--print( "jump vel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y .. ", angle: " .. angle )
		
		
		grounded = false
	end
	
	if action == jump and frame > 1 then
		if jumpX > 0 then
			if actor:GetVelocity().x < jumpX then
				actor:SetVelocity( jumpX, actor:GetVelocity().y )
			end
		elseif jumpX < 0 then
			if actor:GetVelocity().x > jumpX then
				actor:SetVelocity( jumpX, actor:GetVelocity().y )
			end
		end
	--print( "veeeel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
	end
	
	if action == fire then		
		actor:SetVelocity( 0, 0 )
		if frame == 1 then			
			laserAngle = math.atan2( player:GetPosition().y - actor:GetPosition().y, player:GetPosition().x - actor:GetPosition().x )
			actor:CreateBox( bodyTypes.Test, Layer_EnemyHurtbox, math.cos( laserAngle - angle ) * laserHitboxRange/2, math.sin( laserAngle - angle ) * laserHitboxRange/2, laserHitboxRange, 1, laserAngle - angle )
			actor:SetSpriteEnabled( 1, true )
			print( "enabled" )
			--actor:SetSpriteAngle( 1, spriteAngle)
			local xs = 7
			actor:SetSpriteScale( 1, xs, 1 )
			
			if actor:IsFacingRight() then
				--actor:SetSpriteOffset( 1, math.cos( laserAngle ) * ( 250 * xs/64) + math.cos( angle ) * .4, math.sin( laserAngle) * ( 250 * xs/64 ) + math.sin( angle ) * .4 )
			else
				--actor:SetSpriteOffset( 1, math.cos( laserAngle ) * ( 250 * xs/64) + math.cos( angle ) * -.4, math.sin( laserAngle) * ( 250 * xs/64 ) + math.sin( angle ) * -.4 )
			end
			actor:SetSpriteAngle( 1, laserAngle / math.pi )
		end
		
		
		if frame == 60 then
			actor:ClearHurtboxes()
			actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .7, .82, 0 )
			actor:CreateBox( hitboxTypes.Attack, Layer_EnemyHitbox, math.cos( laserAngle - angle ) * laserHitboxRange/2, math.sin( laserAngle - angle ) * laserHitboxRange/2, laserHitboxRange, 1, laserAngle - angle )
		end
		
		if frame == 80 then
			actor:ClearHitboxes()
			actor:CreateBox( hitboxTypes.Attack, Layer_EnemyHitbox, 0, 0, .7, .82, 0 )
		end
		
		if frame == 100 then
			actor:SetSpriteEnabled( 1, false )
		end
		
		if actor:GetSpriteEnabled( 1 ) then
			actor:SetSprite( 1, laserFire[frame][1], laserFire[frame][2] )
		end
	end
end

function UpdatePrePhysics()	
	--PlayerDistSqr()
	
	
	playerDistSqr = PlayerDistSqr()
	xDiff = player:GetPosition().x - actor:GetPosition().x
	if not player:IsReversed() then	
		yDiff = (player:GetPosition().y + .76) - actor:GetPosition().y	
	else
		yDiff = (player:GetPosition().y - .76) - actor:GetPosition().y
	end
	
	
	
	actionChanged = false
	
	ActionEnded()
	
	actor:ClearActorsAttacked()
	
	if not activated and playerDistSqr < activationRangeSqr then 
		activated = true
		--print( "Activated" )
	end
	
	if not activated then return end
	--actor:ClearActorsAttacked()
	
	if slowCounter == 0 then
	
		
		
		
		
		ChooseAction()
		
		
		
		
		--spriteAngle = angle
		
		
		HandleAction()
		
		
		if framesInAir > 5 then--or ( rcCount == 1 and groundNormal.x ~= 0 ) then
			angle = 0    
			spriteAngle = 0
        end
		
		actor:SetBodyAngle( angle )
	
		--print( "Vel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
		--actor:SetVelocity( 0, 0 )
		grav = .5
	
		if not grounded then
			actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + grav )
			--actor:SetBodyAngle( 0 )
			--framesInAir = framesInAir + 1
			--actor:SetVelocity( actor:GetVelocity().x - norm.x * grav, actor:GetVelocity().y - norm.y *  grav )
		end
		
		if actor:GetVelocity().x > 20 then
			actor:SetVelocity( 20, actor:GetVelocity().y )
		elseif actor:GetVelocity().x < -20 then
			actor:SetVelocity( -20, actor:GetVelocity().y )
		end
		
		if actor:GetVelocity().y > 20 then
			actor:SetVelocity( actor:GetVelocity().x, 20 )
		elseif actor:GetVelocity().y < -20 then
			actor:SetVelocity( actor:GetVelocity().x, -20 )
		end
		
		if not grounded then framesInAir = framesInAir + 1 end
		--print( "spider vel1: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
		groundNormal.x = 0
		groundNormal.y = -1
		--lastGrounded = grounded
		--grounded = false
		trueGrounded = false
		touchingRightWall = false
        touchingLeftWall = false
		prevVelocity.x = actor:GetVelocity().x --- carryVel.x
        prevVelocity.y = actor:GetVelocity().y --- carryVel.y
        
		--end
	end

	if slowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
		oldSlowFactor = slowFactor
		slowFactor = 1
	end
	
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
	actor:SetSpriteAngle( 0, spriteAngle)
	
	--[[if action == run then
		print( "run" )
	elseif action == turn then
		print( "turn" )
	elseif action == rush then
		print( "rush" )
	elseif action == rushPrepare then
		print( "rushPrepare" )
	elseif action == idle then
		print( "idle" )
	elseif action == fire then
		print( "fire" )
	elseif action == jump then
		print( "jump" )
	elseif action == root then
		print( "root" )
	elseif action == unroot then
		print( "unroot" )
	elseif action == lob then
		print( "lob" )
	end--]]
	
	--print( "vel1: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
end

function UpdatePostPhysics()

	if not activated then return end
--	print( "vel2: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
	slowCounter = slowCounter + 1

	if slowCounter >= slowFactor then
		frame = frame + 1
		slowCounter = 0

		goingOverCorner = false
		if not hit and rcHit and not changed then
			if (rcNormal.x ~= norm.x or rcNormal.y ~= norm.y) then
				goingOverCorner = true
				--print( "-----------------------")
			--	print( "runspeed: " .. runSpeed )
				if actor:IsFacingRight() then
					actor:SetVelocity( -rcNormal.y * runSpeed, rcNormal.x * runSpeed )
				else
					actor:SetVelocity( rcNormal.y * runSpeed, -rcNormal.x * runSpeed )
				end
				
				local oldNormX = norm.x
				local oldNormY = norm.y
				norm.x = rcNormal.x
				norm.y = rcNormal.y
			end
		end
		changed = false
		hit = false
		rcHit = false
		
		local rightDir = ACTOR:b2Vec2()
		rightDir.x = -norm.y
		rightDir.y = norm.x
		
		canMoveFarther = false
		
		local nextDir = ACTOR:b2Vec2()
		if actor:IsFacingRight() then
			nextDir.x = -norm.y
			nextDir.y = norm.x
		else
			nextDir.x = norm.y
			nextDir.y = -norm.x
		end
		
		local stop1 = 0
		local stop2 = 0
		
		xDiff = player:GetPosition().x - actor:GetPosition().x
		if not player:IsReversed() then	
			yDiff = (player:GetPosition().y + .76) - actor:GetPosition().y	
		else
			yDiff = (player:GetPosition().y - .76) - actor:GetPosition().y
		end
		
		if action == run and not stopped then
			if not goingOverCorner then
				if not chasing then
					local dirDiff = math.abs( nextDir.x ) - math.abs( nextDir.y )
					local distDiff = math.abs( xDiff ) - math.abs( yDiff )
					--local angleBetween = math.atan2( -xDiff, -yDiff )
					--angleBetween = -angleBetween
					
					--if math.abs( angleBetween - angle ) < .1 then
					--	--canMoveFarther = false
					--	print( "angle between: " .. angleBetween .. ", angle: " .. angle )
					--end
					--
					local previousFacingRight = actor:IsFacingRight()
					if dirDiff > 0 or dirDiff == 0 and distDiff > 0 then
						--print( "First")
						--print( "dirDiff: " .. dirDiff .. ", distDiff: " .. distDiff .. ", xDiff: " .. xDiff )
						
						if xDiff > 0 and rightDir.x > 0 then
							canMoveFarther = true
							actor:FaceLeft()
						--	print( "1-1" )
						elseif xDiff < 0 and rightDir.x > 0 then
							canMoveFarther = true
							actor:FaceRight()
						--	print( "1-2" )
						elseif xDiff > 0 and rightDir.x < 0 then
							canMoveFarther = true
							actor:FaceRight()			
						--	print( "1-3" )
						elseif xDiff < 0 and rightDir.x < 0 then
							canMoveFarther = true
							actor:FaceLeft()
							--print( "1-4" )
						elseif yDiff > 0 and rightDir.y > 0 then
							actor:FaceLeft()
							canMoveFarther = true
							--print( "1-5" )
						elseif yDiff < 0 and rightDir.y > 0 then
							actor:FaceRight()
							canMoveFarther = true
							--print( "1-6" )
						elseif yDiff > 0 and rightDir.y < 0 then
							actor:FaceRight()
							canMoveFarther = true
							--print( "1-7" )
						elseif yDiff < 0 and rightDir.y < 0 then
							actor:FaceLeft()
							canMoveFarther = true	
							--print( "1-8" )
						end
						--print( " " )
						if canMoveFarther then
							if previousFacingRight == actor:IsFacingRight() then
								switchCounter = 0
							else
								switchCounter = switchCounter + 1
							end
							
							if actor:IsFacingRight() then
							--	print( "setvelright: " .. (runSpeed * -norm.y) .. ", " ..  (runSpeed * norm.x) )
							--	print( "norm: " .. norm.x .. ", " .. norm.y )
								actor:SetVelocity( runSpeed * -norm.y, runSpeed * norm.x )
							else
							--	print( "setvelleft: " .. (runSpeed * norm.y) .. ", " ..  (runSpeed * -norm.x) )
							--	print( "norm: " .. norm.x .. ", " .. norm.y )
								actor:SetVelocity( runSpeed * norm.y, runSpeed * -norm.x )
							end
							
						end
					elseif dirDiff < 0 or dirDiff == 0 and distDiff < 0 then
						--print( "Second" )
						--print( "dirDiff: " .. dirDiff .. ", distDiff: " .. distDiff .. ", xDiff: " .. xDiff )
						if yDiff > 0 and rightDir.y > 0 then
							actor:FaceLeft()
							canMoveFarther = true
						--	print( "2-1" )
						elseif yDiff < 0 and rightDir.y > 0 then
							actor:FaceRight()
							canMoveFarther = true
						--	print( "2-2" )
						elseif yDiff > 0 and rightDir.y < 0 then
							actor:FaceRight()
							canMoveFarther = true
						--	print( "2-3" )
						elseif yDiff < 0 and rightDir.y < 0 then
							actor:FaceLeft()
							canMoveFarther = true
						--	print( "2-4" )				
						elseif xDiff > 0 and rightDir.x > 0 then
							canMoveFarther = true
							actor:FaceLeft()
					--		print( "2-5" )
						elseif xDiff < 0 and rightDir.x > 0 then
							canMoveFarther = true
							actor:FaceRight()
							--print( "2-6" )----------------------------------------
						elseif xDiff > 0 and rightDir.x < 0 then
							canMoveFarther = true
							actor:FaceRight()			
					--		print( "2-7" )
						elseif xDiff < 0 and rightDir.x < 0 then
							canMoveFarther = true
							actor:FaceLeft()
					--		print( "2-8" )
						end
						
						if canMoveFarther then
							if previousFacingRight == actor:IsFacingRight() then
								switchCounter = 0
							else
								switchCounter = switchCounter + 1
							end
							
							if actor:IsFacingRight() then
								actor:SetVelocity( runSpeed * -norm.y, runSpeed * norm.x )
							--	print( "setvelright: " .. (runSpeed * -norm.y) .. ", " ..  (runSpeed * norm.x) )
							--	print( "norm: " .. norm.x .. ", " .. norm.y )
							else
								actor:SetVelocity( runSpeed * norm.y, runSpeed * -norm.x )
							--	print( "setvelright: " .. (runSpeed * -norm.y) .. ", " ..  (runSpeed * norm.x) )
							--	print( "norm: " .. norm.x .. ", " .. norm.y )
							end
						end
					else
						
				--		print( "Third" )
					end
				else
					--is chasing
			
					
					--print( "chasing start" )
					local dirDiff = math.abs( nextDir.x ) - math.abs( nextDir.y )
					local distDiff = math.abs( xDiff ) - math.abs( yDiff )
					--
					local previousFacingRight = actor:IsFacingRight()
					
					local angleBetween = math.atan2( -xDiff, -yDiff )
					angleBetween = -angleBetween
					
					local testAngle = angleBetween - angle
					--print( "original testAngle: " .. testAngle )
					--if testAngle < 0 then testAngle = testAngle + math.pi * 2 end
					--if testAngle > math.pi * 2 then testAngle = testAngle - math.pi * 2 end
					
					--print( "TestAngle: " .. testAngle )
					if math.abs(testAngle) < .1 or math.abs(math.abs(testAngle) - math.pi) < .1  then
					--	--canMoveFarther = false
						--print( "angle between: " .. angleBetween .. ", angle: " .. angle )
					--end
					
					
					elseif dirDiff > 0 or dirDiff == 0 and distDiff > 0 then
						--print( "First")
						--print( "dirDiff: " .. dirDiff .. ", distDiff: " .. distDiff .. ", xDiff: " .. xDiff )
						
						if xDiff > 0 and rightDir.x > 0 then
							canMoveFarther = true
							actor:FaceRight()
						--	print( "1-1" )
						elseif xDiff < 0 and rightDir.x > 0 then
							canMoveFarther = true
							actor:FaceLeft()
						--	print( "1-2" )
						elseif xDiff > 0 and rightDir.x < 0 then
							canMoveFarther = true
							actor:FaceLeft()			
						--	print( "1-3" )
						elseif xDiff < 0 and rightDir.x < 0 then
							canMoveFarther = true
							actor:FaceRight()
							--print( "1-4" )
						elseif yDiff > 0 and rightDir.y > 0 then
							actor:FaceRight()
							canMoveFarther = true
							--print( "1-5" )
						elseif yDiff < 0 and rightDir.y > 0 then
							actor:FaceLeft()
							canMoveFarther = true
							--print( "1-6" )
						elseif yDiff > 0 and rightDir.y < 0 then
							actor:FaceLeft()
							canMoveFarther = true
							--print( "1-7" )
						elseif yDiff < 0 and rightDir.y < 0 then
							actor:FaceRight()
							canMoveFarther = true	
							--print( "1-8" )
						end
						--print( " " )
						if canMoveFarther then
							if previousFacingRight == actor:IsFacingRight() then
								switchCounter = 0
							else
								switchCounter = switchCounter + 1
							end
							
							if actor:IsFacingRight() then
							--	print( "setvelright: " .. (runSpeed * -norm.y) .. ", " ..  (runSpeed * norm.x) )
							--	print( "norm: " .. norm.x .. ", " .. norm.y )
								actor:SetVelocity( runSpeed * -norm.y, runSpeed * norm.x )
							else
							--	print( "setvelleft: " .. (runSpeed * norm.y) .. ", " ..  (runSpeed * -norm.x) )
							--	print( "norm: " .. norm.x .. ", " .. norm.y )
								actor:SetVelocity( runSpeed * norm.y, runSpeed * -norm.x )
							end
						else
							--print( "1.. xDiff: " .. xDiff .. ", yDiff: " .. yDiff .. ", rightDir: " .. rightDir.x .. ", " .. rightDir.y )
						end
					elseif dirDiff < 0 or dirDiff == 0 and distDiff < 0 then
						--print( "Second" )
						--print( "dirDiff: " .. dirDiff .. ", distDiff: " .. distDiff .. ", xDiff: " .. xDiff )
						if yDiff > 0 and rightDir.y > 0 then
							actor:FaceRight()
							canMoveFarther = true
						--	print( "2-1" )
						elseif yDiff < 0 and rightDir.y > 0 then
							actor:FaceLeft()
							canMoveFarther = true
						--	print( "2-2" )
						elseif yDiff > 0 and rightDir.y < 0 then
							actor:FaceLeft()
							canMoveFarther = true
						--	print( "2-3" )
						elseif yDiff < 0 and rightDir.y < 0 then
							actor:FaceRight()
							canMoveFarther = true
						--	print( "2-4" )				
						elseif xDiff > 0 and rightDir.x > 0 then
							canMoveFarther = true
							actor:FaceRight()
					--		print( "2-5" )
						elseif xDiff < 0 and rightDir.x > 0 then
							canMoveFarther = true
							actor:FaceLeft()
							--print( "2-6" )----------------------------------------
						elseif xDiff > 0 and rightDir.x < 0 then
							canMoveFarther = true
							actor:FaceLeft()			
					--		print( "2-7" )
						elseif xDiff < 0 and rightDir.x < 0 then
							canMoveFarther = true
							actor:FaceRight()
					--		print( "2-8" )
						end
						
						if canMoveFarther then
							if previousFacingRight == actor:IsFacingRight() then
								switchCounter = 0
							else
								switchCounter = switchCounter + 1
							end
							
							if actor:IsFacingRight() then
								actor:SetVelocity( runSpeed * -norm.y, runSpeed * norm.x )
							--	print( "setvelright: " .. (runSpeed * -norm.y) .. ", " ..  (runSpeed * norm.x) )
							--	print( "norm: " .. norm.x .. ", " .. norm.y )
							else
								actor:SetVelocity( runSpeed * norm.y, runSpeed * -norm.x )
							--	print( "setvelright: " .. (runSpeed * -norm.y) .. ", " ..  (runSpeed * norm.x) )
							--	print( "norm: " .. norm.x .. ", " .. norm.y )
							end
						else
						--	print( "2.. xDiff: " .. xDiff .. ", yDiff: " .. yDiff .. ", rightDir: " .. rightDir.x .. ", " .. rightDir.y )
						end
					else
						
						--print( "Third" )
					end
					--print( "chasing" )
				end
				
			else
				canMoveFarther = true
			--	print( "going over corner" )
			end
			
			
			setrun = false
		end
		stopped = false
	
		
		if playerDistSqr > 5^2 then
			if actor:IsFacingRight() then
				--actor:FaceLeft() 
			else
				--actor:FaceRight()
			end
			--actor:SetVelocity( -actor:GetVelocity().x, -actor:GetVelocity().y )
		end
		
	end
	--actor:SetVelocity( actor:GetVelocity().x / oldSlowFactor, actor:GetVelocity().y / oldSlowFactor )
	
	
	if oldSlowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x * oldSlowFactor, actor:GetVelocity().y * oldSlowFactor )
		oldSlowFactor = 1
	end
	--collectgarbage()
end

function SetAction( newAction )
	if action ~= nil then
		prevAction = action
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
	hurt = true
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
	--print( "stagecolstart" )
	if not activated then return true end
	
	if framesInAir > 10 then
		grounded = true
		framesInAir = 0

		
	elseif framesInAir > 8 then
		instantJump = true
		grounded = true
	end

	--print( "NORMAL: " .. normal.x .. ", " .. normal.y )
	if (normal.x ~= norm.x or normal.y ~= norm.y) and not changed and (action == run or action == jump) and grounded or setrun or instantJump then
		--print( "set crawler: " .. normal.y .. ", " .. -normal.x )
		--actor:SetVelocity( normal.y * runSpeed, -normal.x * runSpeed )
		--changed = true
		if not setrun then
			local nextDir = ACTOR:b2Vec2()
			if actor:IsFacingRight() then
				nextDir.x = -normal.y
				nextDir.y = normal.x
			else
				nextDir.x = normal.y
				nextDir.y = -normal.x
			end
			
			local stop1 = 0
			local stop2 = 0
			
			if not chasing then
				if xDiff > 0 and nextDir.x > 0 or xDiff < 0 and nextDir.x < 0 then
					stop1 = nextDir.x
				end
				if yDiff > 0 and nextDir.y > 0 or yDiff < 0 and nextDir.y < 0 then
					stop2 = nextDir.y
				end
			
			--if stop1 ~= 0 and stop2 ~= 0 and  then stopped = true end
			
				if stop1 ~= 0 and math.abs(nextDir.x) - math.abs( nextDir.y )  > 0 then
					stopped = true
					--print( "first stop" )
				elseif stop2 ~= 0 and math.abs( nextDir.y ) - math.abs( nextDir.x ) > 0 then
					stopped = true
					--print( "second stop" )
				elseif stop1 and stop2 then
					--stopped = true
					--print( "double stop" )
				end
			else
			--	print( "chase stopping zone" )
				if xDiff > 0 and nextDir.x < 0 or xDiff < 0 and nextDir.x > 0 then
					stop1 = nextDir.x
				end
				if yDiff > 0 and nextDir.y < 0 or yDiff < 0 and nextDir.y > 0 then
					stop2 = nextDir.y
				end
				
				
				
				--if stop1 ~= 0 and stop2 ~= 0 then stopped = true end
				
				if stop1 ~= 0 and math.abs(nextDir.x) - math.abs( nextDir.y )  > 0 then
					stopped = true
					--print( "first stop" )
				elseif stop2 ~= 0 and math.abs( nextDir.y ) - math.abs( nextDir.x ) > 0 then
					stopped = true
					--print( "second stop" )
				elseif stop1 and stop2 then
					--stopped = true
					--print( "double stop" )
				end
				
				--if stopped then print( "IM STOPPED YO" ) end
			end
		end
		
		angle = math.atan2( normal.x, -normal.y )
		spriteAngle = angle / math.pi
		--if stop1 or stop2 then stopped = true end
		if stopped then
			norm.x = normal.x
			norm.y = normal.y
			--print( "would be setting normals here" )
		end
		
		if not stopped then
			--print( "SET NORM: " .. normal.x .. ", " .. normal.y )
			if actor:IsFacingRight() then
				actor:SetVelocity( runSpeed * -normal.y, runSpeed * normal.x )
			else
				actor:SetVelocity( normal.y * runSpeed, -normal.x * runSpeed )
			end
			actor:SetVelocity( actor:GetVelocity().x / oldSlowFactor, actor:GetVelocity().y / oldSlowFactor )
			--print( "Stageset: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
			norm.x = normal.x
			norm.y = normal.y
			changed = true
			angle = math.atan2( normal.x, -normal.y )
			spriteAngle = angle / math.pi
		end
	end
	
	--angle = math.atan2( normal.x, -normal.y )
	--spriteAngle = angle / math.pi
	
	local testY = point1.y
	if pointCount == 2 then
			testY = math.min( testY, point2.y )
	end
	
	if enabled and normal.x > wallThreshold and testY < actor:GetPosition().y + playerHeight then
		touchingLeftWall = true
	elseif enabled and normal.x < -wallThreshold and testY < actor:GetPosition().y + playerHeight then
		touchingRightWall = true
	end

	--print( "stagecolend" )
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
		slowFactor = tag
		return 0
	end
	
	return 0
end

function Die()
	
end

function PlayerDistSqr()
	local playerPos = player:GetPosition()
	if not player:IsReversed() then	
		playerPos.y = player:GetPosition().y + .76
	else
		playerPos.y = player:GetPosition().y - .76
	end
	
	local selfPos = actor:GetPosition()
	local distSqr = ( playerPos.x - selfPos.x )^2 + ( playerPos.y - selfPos.y )^2
	return distSqr
end


