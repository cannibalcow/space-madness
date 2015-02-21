local Monster = {}
Monster.__index = Monster

setmetatable(Monster, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Monster.new()
    this = setmetatable({}, Monster)
end

return Monster