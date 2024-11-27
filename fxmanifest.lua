fx_version 'cerulean'
game 'gta5'

name "cb-unionheist"
description "A Union Heist for FiveM RP servers"
author "Cool Brad Scripts"
version "1.0.1"

lua54 'yes'
use_experimental_fxv2_oal 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}

/* Open Source */
escrow_ignore {
	'client/*.lua',
	'server/*.lua',
	'shared/*.lua'
}

/* Escrow
escrow_ignore {
	'client/framework.lua',
	'server/framework.lua',
	'shared/*.lua'
}
*/