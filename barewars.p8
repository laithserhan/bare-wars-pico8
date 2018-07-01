pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- bare wars
-- by john weachock

-- https://github.com/eevee/klinklang/blob/23c5715bda87f3c787e1c5fe78f30443c7bf3f56/object.lua
local object = {}
object.__index = object


-- constructor
function object:__call(...)
  local this = setmetatable({}, self)
  return this, this:init(...)
end


-- methods
function object:init()
end

function object:update()
end

function object:draw()
end


-- subclassing
function object:extend(proto)
  proto = proto or {}

  -- copy meta values, since lua doesn't walk the prototype chain to find them
  for k, v in pairs(self) do
    if sub(k, 1, 3) == "__" then
      proto[k] = v
    end
  end

  proto.__index = proto
  proto.__super = self

  return setmetatable(proto, self)
end


-- implementing mixins
function object:implement(...)
  for _, mixin in pairs{...} do
    for k, v in pairs(mixin) do
      if self[k] == nil and type(v) == "function" then
        print("assigning", k)
        self[k] = v
      end
    end
  end
end


-- typechecking
function object:isa(class)
  local meta = getmetatable(self)
  while meta do
    if meta == class then
      return true
    end
    meta = getmetatable(meta)
  end
  return false
end

-- camera object

_camera = object:extend()

function _camera:init()
  self.x = 0
  self.y = 0
  self.tx = 0
  self.ty = 0
end

function _camera:move(x, y)
  self.tx = x
  self.ty = y
end

function _camera:dmove(dx, dy)
  self.tx += dx
  self.ty += dy
end

function _camera:update()
  if (self.x <= self.tx - 1) or (self.x >= self.tx + 1) then
    self.x = (self.x + self.tx) / 2
  end
  if (self.y <= self.ty - 1) or (self.y >= self.ty + 1) then
    self.y = (self.y + self.ty) / 2
  end
end

function _camera:draw()
  camera(self.x, self.y)
end

-- sprite object

_sprite = object:extend()

function _sprite:init(tile, x, y, transparent)
  self.tile = tile
  self.x = x
  self.y = y
  self.transparent = transparent or 8
end

function _sprite:draw()
  palt(self.transparent, true)
  palt(0, false)
  spr(self.tile, self.x, self.y)
  palt()
end

sprites = {}
curs = _sprite(1, 64, 64, 8)
cam = _camera()
add(sprites, curs)

function _init()
end

function _update()
  cam:update()

  for sprite in all(sprites) do
    sprite:update()
  end

  if btnp(0) then cam:dmove(-8, 0) end
  if btnp(1) then cam:dmove(8, 0) end
  if btnp(2) then cam:dmove(0, -8) end
  if btnp(3) then cam:dmove(0, 8) end
  if btnp(4) then cam:dmove(36 * 8, 0) end
  if btnp(5) then cam:dmove(-36 * 8, 0) end
end

function _draw()
  cls()

  cam:draw()
  map(0, 0)

  for sprite in all(sprites) do
    sprite:draw()
  end
end

__gfx__
00000000007777000000000000000000000000008944449889444498894444983333333300000000000000000000000000000000000000000000000000000000
00000000088888800000000000000000000000008444444884444448844444483333333300000000000000000000000000000000000000000000000000000000
00700700788888870000000000000000000000008404404844044048840440443333333300000000000000000000000000000000000000000000000000000000
00077000788888870000000000000000000000004444044444440448844404443333333300000000000000000000000000000000000000000000000000000000
00077000788888870000000000000000000000004444444484444444444444483333333300000000000000000000000000000000000000000000000000000000
00700700788888870000000000000000000000008449944884499444444994483333333300000000000000000000000000000000000000000000000000000000
00000000088888800000000000000000000000008449944884499448844994483333333300000000000000000000000000000000000000000000000000000000
00000000007777000000000000000000000000008448844884488888888884483333333300000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008677776800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008777777800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008707707800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007777077700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008776677800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008776677800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008778877800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008511115800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008111111800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008101101800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111011100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008115511800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008115511800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008118811800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333333333333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
3333333333bb333333bbbb3333344333333bb3333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
3333333333b333b33b2b2bb33344443333bbbb333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
3333333333333bb33bbbb2b33399993333bbbb333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
333333333b3333333b2bbbb3334444333bbbbbb33333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
333333333bb33b3333bb2b3333999933333443333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
3333333333333bb3333bb33333444433333443333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333333333333333333333333333333333330000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
dddddddddddd5ddddddccddddddccddddddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
dddddddddd5dddddddccccddddc7ccddddd5dddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
ddddddddddddd5ddddcc1ccdddcc7cdddd555ddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
ddddddddd5dddddddcc111cddd7cc7dddd5555dddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
dddddddddddd5ddddcc11cddddc7ccddd555555ddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
dddddddddd5ddd5dddccccdddddc7dddd555555ddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444444444444444444444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
444444444494494444bbe44444444444443333444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
444444444949449444ebb4e444455444433333344444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
4444444444444944444b44be447ee744433333344444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
44444444444944444bbb4bb4447ee744443333444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
44444444449449444e4bbb44447ee744444554444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
44444444444944944444b44444777744444554444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444444444444444444444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
__map__
4040404040404040404040404040404040404040404040404040404040404040404040404060606060606060606060606060606060606060606060606060606060606060606060606050505050505050505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404060606060606060606060606060606060606060606060606060606060606060606060606050505050505050505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404041404040414040404040434040404040404040424040404040404060606060606060606060606061606060606060606060606060606060606060606064606050505050505050505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404440404040404040404040404060606060606260606060606060606060606060606360606060606060606060606060606050505050505050505050505050505450505050505050505050505054505050505050505000000000000000000000000000000000000000
4040404140404040414040404040404040404040404040404040404040404040404040404060606060606060606060606060606060606060606060606060616060606060606060606050505050515050505050505050505050505250505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404140404040404040404041404040404060606060606060606060606060606060606060606060606060606060636060606060606050505050505050505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404060606060606060606064606060606060606060606060606060646060606060606060606050505050505050505053505051505050505050505150505050505050505050505050505000000000000000000000000000000000000000
4040404040414040404440404041404040404040404040404040404040404040404040404060606060606061606060606060636060606061606060606060606060606060606060606050505050505050505050505050505050505050505050505050505050505050515050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040414040404040404040404060606060606060606060606060606060606060606060606060606060606060606064606050505050505250505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404042404040404040444040404040404040404040404060606060606060606060606060606060606060606060606260606061606060606060606050505050505050505050505052505050505050505050505350505050505050505050505000000000000000000000000000000000000000
4040404340404040404040404040404040404040404040404040404040404040404040404060606060606060606060606160606060606060606060606060606060606060606060606050505050505050505050505050505050505050505050505050505450505050505050505000000000000000000000000000000000000000
4040404040404040404042404040404040404040414040404040404040404040424040404060606060626060606060606060606060606060636060606060606060606060606060606050505050505054505050505050505050545050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040444040404040404043404040404140404040404040404060606060606060606060606060606062606060606060606060606060606064606060606050505050505050505050505050505050535050505051505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404060606060606060606060646060606060606060606060616060606060606060606060606050505050505050505050505150505050505050505050505050505050505050525050505000000000000000000000000000000000000000
4040404040414040404040404040404040404040404040404040404040404040404040404060606060606060636060606060606060606060606060606060606062606060606060606050505050525050505050505050505050505050505050505050505350505050505050505000000000000000000000000000000000000000
4040404040404040404041404040404041404040404040404040404040404040404040404060606060606060606060606060616060646060606060606060606060606060606060606050505050505050545050505050505050505250505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404044404040404040404040434040404060606060606060606060616060606060606060606060606360606060606060606060606050505050505050505050505050505050505050505050505050505050505054505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404060606060606060606060606060606060606060606060606060606060606060616060606050505050505050505050505050535050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404340404040404040404040404040404040404040404040424040404041404040404060606060616060606060606060606060606061606060606060606060606060606060606050505050505050515050505050505050505050545050505051505050505050505050505000000000000000000000000000000000000000
4040404040404040404044404040414040404043404040404040404040404040404040404060606060606060606060606460606060606060606060606060606260606060606060606050505050505050505050505050505050505050505050505050505050525050505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404060606060606060606060606060606063606060606060606060606060606060606060606050505050505050505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404140404040404040404040404040404040404040404040404040404040404060606060606060626060606060606060606060606060616060606060606360646060606050505050505050505050505050515050505050505050505350505050505050515050505000000000000000000000000000000000000000
4040404040404040404042404040404040404040404140404040404044404040404040404060606060606060606060606060606060606060606060606060606060606060606060606050505050505052505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404044404040404040404040404040404040404040404060606060606060606060616060606060646060606060606060606060606060606060606050505050505050505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404060606060606060606060606060606060606060606060606060606060606060606060606050505050505050505050505050505050505050505050505050505050505050505050505000000000000000000000000000000000000000
__sfx__
00010000260500500030050300503005030040300403003030030300202d0003a6003a6002f0003960038600386003860038600386002e0002d0002a00028000210001d000190001600013000000000000000000
