# Rules List

## Shooter implies 3D
F302 -> F205
## Platformer implies 2D
F303 -> F206
## Shooter + Strategy implies Class-Based Shooter
F302; F304 -> F401
## Fishing implies Resource Management
F403 -> F404
## Pixel Graphics implies 2D
F204 -> F206
## 2D implies Side View
F206 -> F209
## 2D implies Top-down View
F206 -> F208
## Shooter implies Destructibility
F302 -> F207
## Old implies Classic
F609 -> F702
## First Person View implies 3D
F201 -> F205
## Third Person View implies 3D
F202 -> F205
## Triple A + New implies Bad
F605; F608 -> F701
## Horror + Survival implies Survival Horror
F309; F402 -> F310
## Co-Op implies Online
F603 -> F601
## Competitive implies Difficult
F604 -> F612
## Action-RPG implies 3D
F315 -> F205
## Roguelike implies Difficult
F314 -> F612
## Multiplayer implies Online
F614 -> F601
## Singleplayer implies Offline
F613 -> F602
## MOBA + Multiplayer implies Competitive
F313; F614 -> F604
## Retro implies Pixel Graphics
F504 -> F204
## Voxel Graphics implies 3D
F211 -> F205
## Stealth implies Exploration
F405 -> F406
## Exploration implies Story-Driven
F406 -> F607
## Story-Driven + Indie implies Addictive
F607; F606 -> F616
## Survival Horror + Difficult implies Horror
F310; F612 -> F309
## Co-Op + Survival Horror implies 3D
F603; F310 -> F205
## Survival Horror implies Survival
F310 -> F402

# Game Definitions

## Shooter + Destructibility + 3D + Online implies Battlefield
F302; F207; F205; F601 -> F101
## Battlefield + Bad implies Battlefield 2042
F101; F701 -> F102
## Battlefield + Historical implies Battlefield 1
F101; F503 -> F104
## 3D + Online + Survival Horror implies Lethal Company
F205; F601; F310 -> F105
## Story-Driven + Offline + 3D + Puzzle implies Stanley Parable
F607; F602; F205; F305 -> F106
## Class-Based Shooter + 3D + Online + Classic implies Team Fortress 2
F401; F205; F601; F702 -> F107
## Class-Based Shooter + 3D + Online + Bad implies Overwatch
F401; F205; F601; F701 -> F108
## Shooter + 3D + Online + Competitive implies Counter Strike
F302; F205; F601; F604 -> F126
## Counter Strike + Old implies Counter Strike 1.6
F126; F609 -> F109
## Counter Strike + New implies Counter Strike 2
F126; F608 -> F110
## RPG + Casual + Top-down View + Indie implies Stardew Valley
F306; F308; F208; F606 -> F111
## Sandbox + 3D + Resource Management implies Minecraft
F307; F205; F404 -> F112
## Sandbox + 2D + RPG + Resource Management implies Terraria
F307; F206; F306; F404 -> F113
## Platformer + Side View + Difficult + Offline implies Cuphead
F303; F209; F612; F602 -> F114
## Survival + 3D + Resource Management implies The Long Dark
F402; F205; F404 -> F115
## Classic + Side View + Rhythm Game + Difficult implies Chronoheart
F702; F209; F301; F612 -> F116
## Strategy + Turn-Based + Historical implies Civilization
F304; F311; F503 -> F117
## Strategy + Real-Time + Historical implies Hearts of Iron
F304; F312; F503 -> F118
## Strategy + Turn-Based + Sci-Fi implies XCOM
F304; F311; F502 -> F119
## Strategy + Turn-Based + Classic + Old implies Heroes of Might and Magic
F304; F702; F609 -> F120
## Strategy + Competitive + RTS implies Starcraft
F304; F604; F312 -> F121
## 3D + RPG + Fantasy + Story-Driven + Offline implies Skyrim
F205; F306; F501; F607; F602 -> F123
## Resource Management + Top-down View + Difficult + Sci-Fi implies Factorio
F404; F208; F612; F502 -> F124
## Rhythm Game + Difficult + Free implies OSU
F301; F612; F610 -> F125
## Action-RPG + 3D + Story-Driven implies Ghost of Tsushima
F315; F205; F607 -> F130
## Roguelike + Side View + Difficult implies Darkest Dungeon
F314; F209; F612 -> F139
## Addictive + Free Expansions implies Fortnite
F616; F615 -> F132
## Fantasy + Turn-Based + RPG implies Baldur's Gate 3
F501; F311; F306 -> F140
## MOBA + Online + Competitive implies League of Legends
F313; F601; F604 -> F127
## Strategy + Fantasy + Turn-Based implies Heroes of Might and Magic 3
F304; F501; F311 -> F120
## Singleplayer + Fantasy + RPG implies Witcher 3
F613; F501; F306 -> F137
## Simulator + Addictive + Base Building implies The Sims 4
F316; F616; F408 -> F141
## Action RPG + Realistic Graphics + 3D implies Cyberpunk 2077
F315; F203; F205 -> F135
## Crafting + Base Building + Addictive implies Minecraft
F407; F408; F616 -> F112
## Base Building + Simulator + Online implies Fallout Shelter
F408; F316; F601 -> F150
## MOBA + Realistic Graphics + Competitive implies Apex Legends
F313; F203; F604 -> F134
## 2D + Difficult + Platformer + Offline implies Hollow Knight
F612; F612; F303; F602 -> F138
## 3D + Third Person + Difficult implies Dark Souls
F205; F202; F612 -> F129
## Online + Detective Game + Top-down View implies Among Us
F601; F317; F208 -> F133
