shared_script '@av_systems/ai_module_fg-obfuscated.lua'
shared_script '@av_systems/shared_fg-obfuscated.lua'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield



fx_version 'cerulean'
game 'gta5'

server_scripts {
    'config.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

shared_script {
	'@es_extended/imports.lua',
    'config.lua',
}

lua54 'yes'
