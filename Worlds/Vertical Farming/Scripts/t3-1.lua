function fire( entered )
	if entered then
		print('you are on fire')
	else
		print('you stop burning')
	end
end

function camera( entered, pos, halfWidth, halfHeight)
	if entered then
		camControlled = true
		local left = pos.x - halfWidth
		local right = pos.x + halfWidth
		local top = pos.y - halfHeight
		local bottom = pos.y + halfHeight
		--stage:SetCameraPosition( pos.x, pos.y )
		cameraGoal.x = pos.x
		cameraGoal.y = pos.y
		--1920 * 1080
		--16 * 10
		local scaleX = halfWidth * 2 / 30
		local scaleY = halfHeight * 2 / 16.875
		zoomGoal = math.max( scaleX, scaleY )
		--stage:SetCameraZoom( math.max( scaleX, scaleY ) )
		
		
		print( "camera enters" )
	else
		camControlled = false
		print("camera normalizes")
	end
end

function HandleCollision( actor, pos, normal )
	return true
end

function Init()
	player = stage.player
	cameraController = nil
	cameraGoal = STAGE:b2Vec2()
	cameraGoal.x = 0
	cameraGoal.y = 0
	cameraSpeed = .4
	cameraVel = STAGE:b2Vec2()
	cameraVel.x = 0
	cameraVel.y = 0
	cameraMaxVel = 5
	cameraAcc = .1
	--cameraGoal.x = player:GetPosition().x
	--cameraGoal.y = player:GetPosition().y
	zoomGoal = 1
	currentZoom = 1
	zoomRate = .1
	camControlled = false
	--offset = STAGE:b2Vec2()
	maxOffset = STAGE:b2Vec2()
	maxOffset.x = 15
	maxOffset.y = 15
	offsetSpeed = .1
	
	--currentInput = stage.currentInput
	stage:SetCameraFollowX( 0 )
	stage:SetCameraFollowY( 0 )
	stage:SetCameraMaxVelocityX( 200 )
	stage:SetCameraMaxVelocityY( 200 )
	--change this between true and false to show a debug display of the physics objects
	--stage:DebugDrawOn( true, false )
	zoomCount = 0
	maxZoomCount = 60
	
	local pos = STAGE:b2Vec2()
	pos.x = 48
	pos.y = 124
	local vel = STAGE:b2Vec2()
	vel.x = 0
	vel.y = 1
	--stage:CreateActor( "crawler", pos, vel, false, false, 0, nil )
	pos.x = 44
	pos.y = 127
	--stage:CreateActor( "crawler", pos, vel, false, false, 0, nil )
	pos.x = 47
	pos.y = 131
	--stage:CreateActor( "crawler", pos, vel, false, false, 0, nil )
	pos.x = 85
	pos.y = 118
	--stage:CreateActor( "crawler", pos, vel, false, false, 0, nil )
	
	pos.x = 10
	pos.y = 127
	vel.y = 0
	--stage:CreateActor( "mine", pos, vel, false, false, 0, nil )
	
	zoom = 1
	offsetx = 0
	offsety = 0
	maxoffsetx = 6
	maxoffsety = 5
	lastdir = 0
	maxZoom = 2
	
	playerVel = ACTOR:b2Vec2()
	playerVel.x = 0
	playerVel.y = 0
end

function UpdatePrePhysics( )
	zoomGoal = 1
	
	if math.abs( zoomGoal - currentZoom ) < zoomRate then
		currentZoom = zoomGoal
	elseif zoomGoal - currentZoom > 0 then
		currentZoom = currentZoom + math.min( zoomRate, zoomGoal - currentZoom )
	else
		currentZoom = currentZoom - math.min( zoomRate / 3, currentZoom - zoomGoal )
	end
	
	zoomGoal = 1 + ( math.abs(player:GetVelocity().x) * .02)
	
	if math.abs( player:GetVelocity().y ) >= 44  then
		zoom = zoom + .02
	end
	
	
	if math.abs( player:GetVelocity().x ) > 17 then
	
	if zoomGoal > zoom then
		zoom = zoom + .01
		if zoom > zoomGoal then
			zoom = zoomGoal
		end
	end
	
	end
	
	if zoomGoal < zoom then
		zoom = zoom - .01
		if zoom < zoomGoal then
			zoom = zoomGoal
		end
	end
	if zoom > maxZoom then zoom = maxZoom end
	stage:SetCameraZoom( zoom )
	maxoffsetx = 8 * zoom
	maxoffsety = 5 * zoom
end

function UpdatePostPhysics()
	--stage:SetCameraPosition( player:GetPosition().x + offset.x, player:GetPosition().y + offset.y )
	if not camControlled then
		cameraGoal.x = player:GetPosition().x
		cameraGoal.y = player:GetPosition().y
		
		
		if math.abs(stage:GetCameraPosition().x - player:GetPosition().x) < 1 or math.abs(stage:GetCameraPosition().y - player:GetPosition().y ) < 1  then
			--stage:SetCameraPosition( player:GetPosition().x, player:GetPosition().y )
		else
			local xDiff = cameraGoal.x - stage:GetCameraPosition().x 
			local yDiff = cameraGoal.y - stage:GetCameraPosition().y
			local diff = math.sqrt( xDiff * xDiff + yDiff * yDiff )
			local moveX = math.min( cameraSpeed, math.abs( xDiff ) )
			if xDiff < 0 then
				moveX = -moveX
			end
			local moveY = math.min( cameraSpeed, math.abs( yDiff ) )
			if yDiff < 0 then
				moveY = -moveY
			end
			
			--stage:SetCameraPosition( stage:GetCameraPosition().x + moveX, stage:GetCameraPosition().y + moveY )
		end
		
		
	else
		local xDiff = cameraGoal.x - stage:GetCameraPosition().x 
		local yDiff = cameraGoal.y - stage:GetCameraPosition().y
		local diff = math.sqrt( xDiff * xDiff + yDiff * yDiff )
		local moveX = math.min( cameraSpeed, math.abs( xDiff ) )
		if xDiff < 0 then
			moveX = -moveX
		end
		local moveY = math.min( cameraSpeed, math.abs( yDiff ) )
		if yDiff < 0 then
			moveY = -moveY
		end
		
		--stage:SetCameraPosition( stage:GetCameraPosition().x + moveX, stage:GetCameraPosition().y + moveY )
		
		--stage:SetCameraPosition( stage:GetCameraPosition().x + ( cameraGoal.x - stage:GetCameraPosition().x ) / 10, 
		--stage:GetCameraPosition().y + ( cameraGoal.y - stage:GetCameraPosition().y ) / 10 )
	end
	--stage:SetCameraPosition( player:GetPosition().x, player:GetPosition().y )
	
	
	
	--if math.abs( zoomGoal - currentZoom ) < .01 then
	--	currentZoom = zoomGoal
	--else
	--	currentZoom = (zoomGoal - currentZoom)/10 + currentZoom
	--end
	local camx = player:GetPosition().x
	local camy = player:GetPosition().y
	local d = 1
	local s = .1
	--local s = .1
	--11 is walljumpX speed, meaning anything slower than a dash
	if player:GetVelocity().x > 17 then
		offsetx = offsetx + s
		if offsetx > player:GetVelocity().x / d then
			--offsetx = player:GetVelocity().x / d
		end
	elseif player:GetVelocity().x < - 17 then
		offsetx = offsetx - s
		if offsetx < player:GetVelocity().x / d then
			--offsetx = player:GetVelocity().x / d
		end
	else
		if offsetx > 0 then
			offsetx = offsetx - s
			if offsetx < 0 then offsetx = 0 end
		elseif offsetx < 0 then
			offsetx = offsetx + s
			if offsetx > 0 then offsetx = 0 end
		end
	end
	if player:GetVelocity().x > 0 then
		lastdir = 1
		--offsetx = offsetx + s
		--camx = camx + player:GetVelocity().x / 10
	elseif player:GetVelocity().x < 0 then
		lastdir = -1
		--offsetx = offsetx - s
		--camx = camx - player:GetVelocity().x / 10
	end
	--offsetx = offsetx + s * lastdir
	local s2 = .1
	if player:GetVelocity().y > 20 then
		--offsety = offsety + s2
	else
		--offsety = offsety - s2 / 10
	end
	
	if offsetx > maxoffsetx then offsetx = maxoffsetx elseif offsetx < -maxoffsetx then offsetx = -maxoffsetx end
	if offsety > maxoffsety then offsety = maxoffsety elseif offsety < -maxoffsety then offsety = -maxoffsety end
	
	if offsety < 0 then offsety = 0 end
	
	
	local d2 = 5
	--local s2 = .05
	if player:GetVelocity().y >= 0 then
	if player:GetVelocity().y / d2 > offsety then
		--offsety = offsety + s2
		if offsety > player:GetVelocity().y / d2 then
		--	offsety = player:GetVelocity().y / d2
		end
	elseif player:GetVelocity().y / d2 < offsety then
		--offsety = offsety - s2
		if offsety < player:GetVelocity().y / d2 then
		--	offsety = player:GetVelocity().y / d2
		end
	end
	end
	
	--if offsety > maxoffsety then offsety = maxoffsety elseif offsety < -maxoffsety then offsetx = -maxoffsety end
	--print( "fd: " .. player:GetVelocity().y / d2 .. ", offy: " .. offsety )
	
	camx = camx + offsetx
	camy = camy + offsety

	
	--stage:SetCameraZoom( currentZoom )
	--local camx = player:GetPosition().x - player:GetVelocity().x / 20
	--local camy = player:GetPosition().y --- player:GetVelocity().y / 20
	
	
	
	if camx < 15 * zoom then camx = 15 * zoom end
	stage:SetCameraPosition( camx, camy )
	
	
	
	
	--end
	--stage:SetCameraPosition( stage:GetCameraPosition().x + offset.x, stage:GetCameraPosition().y + offset.y )
end

function halfgrav()
	print ("half gravity")
end



--function GetGroundType( 

--print( 'nothing' )
--st:testmethod( 5, true, "yay!" )