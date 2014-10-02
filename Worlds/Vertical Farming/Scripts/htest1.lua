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
	--pos.x = 48
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
	
	playerVel = STAGE:b2Vec2()
	playerVel.x = 0
	playerVel.y = 0
	
	fff = 0
	oldX = 0
	old = STAGE:b2Vec2()
	old.x = -1
	old.y = -1
	
	slowCounter = 0
	--oldX = player:GetPosition().x
end

function UpdatePrePhysics()
end

function UpdatePostPhysics()
end

function halfgrav()
	print ("half gravity")
end



--function GetGroundType( 

--print( 'nothing' )
--st:testmethod( 5, true, "yay!" )