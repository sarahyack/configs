require("cycle-linemode"):setup({
  linemodes = { "size", "btime", "mtime", "owner", "permissions", "none" }
})

require("bunny"):setup({
  hops = {
    { key = "/",          path = "/",                                    },
    { key = "t",          path = "/tmp",                                 },
    { key = "~",          path = "~",              desc = "Home"         },
    { key = "h",          path = "/mnt/hive",      desc = "Hive"         },
    { key = "m",          path = "~/Music",        desc = "Music"        },
    { key = "d",          path = "~/Downloads",    desc = "Downloads"    },
    { key = "D",          path = "~/Documents",    desc = "Documents"    },
    { key = "c",          path = "~/.config",      desc = "Config files" },
    { key = { "l", "s" }, path = "~/.local/share", desc = "Local share"  },
    { key = { "l", "b" }, path = "~/.local/bin",   desc = "Local bin"    },
    { key = { "l", "t" }, path = "~/.local/state", desc = "Local state"  },
    -- key and path attributes are required, desc is optional
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true, -- Enable ephemeral hops, default is true
  tabs = true, -- Enable tab hops, default is true
  notify = false, -- Notify after hopping, default is false
  fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})

require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode="dir" },
	persist = "none",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = true,
	notify = {
		enable = true,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

if os.getenv("NVIM") then
	require("toggle-pane"):entry("min-preview")
end
