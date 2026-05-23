fx_version 'cerulean'
game 'gta5'

description 'BloodLeak Modern Garage System'
author 'Antigravity'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/nui.lua',
    'client/admin.lua'
}

server_scripts {
    'config.lua',
    'server/main.lua',
    'server/admin.lua',
    'server/garage.lua'
}
