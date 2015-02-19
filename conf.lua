function love.conf(t)
	t.title = "Space Madness" -- The title of the window the game is in (string)
	t.version = "0.9.1"         -- The LÖVE version this game was made for (string)
	t.window.width = 1280        -- we want our game to be long and thin.
	t.window.height = 1024
	t.fullscreen = true
	-- For Windows debugging
	t.console = true
end