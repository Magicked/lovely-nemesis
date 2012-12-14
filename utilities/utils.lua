function defaultVideoSettings()
	screen = {
		width = 800,
		height = 600,
		halfWidth = 400,
		halfHeight = 300,
		fullscreen = false,
		vsync = false,
		fsaa = 0
	}
	showFPS = false
	editHelp = true
	editLens = false
end

function defaultSoundSettings()
	volume = {
		master = .5,
		music = .5,
		sfx = .5
	}
end

-- Remove any final \n from a string.
--   s: string to process
-- returns
--   s: processed string
function chomp(s)
    return gsub(s, "\n$", "")
end