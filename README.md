# scuba-diving

# Video: https://www.youtube.com/watch?v=DhvMAapHy1o
# Discord: https://discord.gg/hk55KVG7Dx
# Website: https://game-center.me/

QBCore Framework


# need

qb-target


# add to qb-inventory/ config.lua,,,,  at Config.AttachmentCrafting

        [1] = {
            name = "weapon_assaultrifle",
            amount = 50,
            info = {},
            costs = {
                ["weaponspart"] = 70,
            },
            type = "item",
            slot = 1,
            threshold = 0,
            points = 1,
        },

# after adding reorder the slot numbers below

# add to qb-core/shared/item.lua

		["specialcutter"]						= {["name"] = "specialcutter",       		    		["label"] = "Screw Driver",	 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "specialcutter.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "open some box"},
		["weaponspart"] 		 	 	 		 = {["name"] = "weaponspart", 					["label"] = "Weapons part", 			["created"] = nil, 		["decay"] = 7.0,		["weight"] = 25, 		["type"] = "item", 		["image"] = "weaponspart.png", 						["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Build a weapon."},

# add images to qb-inventory\html\images


"# scuba-diving" 
