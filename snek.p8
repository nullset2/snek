firsttime = true

players = {
  {
    x = 0,
    y = 0,
    direction = 1,
    positions = {},
    score = 0
  },
  {
    x = 128,
    y = 0,
    direction = 0,
    positions = {},
    score = 0
  }
}

function _init()
  cls()
  framerate = 5
  u = 8
  ticks = 0
  
  food = {
    x = flr(rnd(16))*u,
    y = flr(rnd(16))*u
  }

  players[1].x = 0
  players[1].y = 0
  players[1].direction = 1
  players[1].positions = {}

  players[2].x = 128
  players[2].y = 0
  players[2].direction = 0
  players[2].positions = {}

  if firsttime then
    firsttime = false
    print("Get Ready!!!")
    print("3...\^6 2...\^6 1...\^6")
  end
end

function update_facing_direction(i)
  --up--
  if btn(2, i-1) and players[i].direction != 3 then players[i].direction = 2
  end
 
  --down--
  if btn(3, i-1) and players[i].direction != 2 then
   players[i].direction = 3
  end
  
  --left--
  if btn(0, i-1) and players[i].direction != 1 then
   players[i].direction = 0
  end

  --right--
  if btn(1, i-1) and players[i].direction != 0 then
   players[i].direction = 1
  end
end

function update_position(i)
  if players[i].direction == 2 then
    players[i].y -= u
  elseif players[i].direction == 3 then
    players[i].y += u
  elseif players[i].direction == 0 then
    players[i].x -= u
  elseif players[i].direction == 1 then
    players[i].x += u
  end
end

function update_food_position()
  food.x = flr(rnd(16))*u
  food.y = flr(rnd(16))*u
end

-- param: i (player)
function check_collision(i)
  --if it's out of bounds
  if(players[i].x >= 128 or
     players[i].x < 0 or
     players[i].y >= 128 or
     players[i].y < 0) then
    print("P"..(#players+1-i).." scores!")
    players[#players+1-i].score += 1
    print("3...\^6 2...\^6 1...\^6")
    _init()
  end

  --if a player collides with its own body  
  for v in all(players[i].positions) do
    if players[i].x == v[1] and players[i].y == v[2] then
      print("P"..(#players+1-i).." scores!")
      players[#players+1-i].score += 1
      _init()
    end
  end

  --if p2 collides with p1
  for v in all(players[1].positions) do
    if players[2].x == v[1] and players[2].y == v[2] then
      print("P1 scores!")
      players[1].score += 1
      _init()
    end
  end

  --if p1 collides with p2
  for v in all(players[2].positions) do
    if players[1].x == v[1] and players[1].y == v[2] then
      print("P2 scores!")
      players[2].score += 1
      _init()
    end
  end
end

function _update()
  ticks += 1

  for i, _ in pairs(players) do
    if(players[i].score == 10) then
      print("P"..i.." wins!!!!!!")
      stop()
    end

    update_facing_direction(i)
    
    if(ticks % framerate == 0) then
      update_position(i)
      check_collision(i)
      --check if food was eaten    
      if(players[i].x == food.x and players[i].y == food.y) then
        update_food_position()
      else
        --shift
        deli(players[i].positions, 1)
      end
      --stack
      add(players[i].positions, {players[i].x, players[i].y})
    end
  end
end

function _draw()
  cls()
  map(0, 0, 0, 0, 128, 32)
  for i, _ in pairs(players) do
    print("P"..i.." = "..players[i].score)
    for k, v in pairs(players[i].positions) do
      spr(i, v[1], v[2])
    end
  end
  spr(5, food.x, food.y)
end
