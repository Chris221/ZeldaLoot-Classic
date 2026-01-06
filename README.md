# [ZeldaLoot Classic](https://www.curseforge.com/wow/addons/zeldaloot-classic)
Based on [ZeldaLoot Extended](https://www.curseforge.com/wow/addons/zeldaloot) (abandoned now) which was based on the original [ZeldaLoot from Rickyk](http://wow.curseforge.com/addons/project-15326/) (abandoned), I used to love this addon so I decided to create a WoW Classic version. It will play zelda sounds when you loot an uncommon (green) or better item, may be useful after raid sessions to know if you have won or just as a sound enhancement. I do plan to upgrade the addon further.

## New features summary
### Version Support
We now support all client versions.

### Sounds
4 new sounds for different item qualities, from uncommon (green) to legendary (orange). Note inherited objects (linked to account) can play sound when received too (same as for legendaries items). Sounds provided by: Darth Killer, from Zelda Ocarina of Time (original from games), and Chrisgess, from *Zelda Ocarina of Time Orchestrated* album [www.zreomusic.com](http://zreomusic.com/), even higher sound quality!

The audio plays on the SFX audio channel.

### Interface
Configure which sounds you want and when: loot from enemies, received (letterbox, seller, etc), crafted (professions and some special items like Eternal Water). Settings will be saved between sessions for all your characters. Type **/zeldaloot** or **/zl** for the settings menu.

### Localization
English, French, Spanish, German, and Russian languages are supported, and you can write your own, see files in **\Locale** subdirectory

**If you are using another language please let me know to ensure you are receiving the notifications and not missing the sound effects**

## Changes
### Changes in 2.2.0
- Updated for The War Within (Retail 11.1.7)
- Updated for Classic Era (1.15.7)
- Updated for Cataclysm Classic (4.4.2)
- Fixed compatibility with new Settings API (InterfaceOptions_AddCategory was removed in 10.0)
- Added proper Cata.toc file for Cataclysm Classic
- Cleaned up the code

### Changes in 2.1.0
- Added Locale text for the tooltips and all text sent to the console

### Changes in 2.0.1
- Added support for Vanilla

### Changes in 2.0.0
- Now with mp3 files
- The settings panel has been moved in to the interface settings for easier access
- The settings no longer need to be saved for them to take effect
- You can control the file types and the audio channel from the settings now
- The settings now has toggles for warnings and debug mode (**VERY SPAMMY**)
- **/zl** and **/zeldaloot** now take you to the new panel
- You can also default the settings from the new panel
- Added support for Russian

### Changes in 1.3.0
- There are new warnings if the sound fails to play for any reason. You can disable these with **/zl warnings**.
- Use **/zl ext** to switch file types. This will be an actual settings option in the future.
- Use **/zl channel <channel>** to change the audio channel the sound effect plays on; **the default is SFX (Sound)**. This will be an actual settings option in the future.
  - Channel options: 
    - "Master"
    - "SFX"
    - "Music"
    - "Ambience"
    - "Dialog"
- Re-added old files to ensure all clients work

### Changes in 1.2.5
- It will now prevent running multiple sounds at the same time.
- Reduced the size by correcting the sound files
- Files should be supported on all clients

### Changes in 1.2.4
- Updated for version 3.4.0
- Changed the name from "ZeldaLoot BCC" to "ZeldaLoot Classic"

### Changes in 1.2.3
- Updated for version 2.5.2

### Changes in 1.2.2
- Converted the sound files from ogg to wav.

### Changes in 1.2.1
- Added a help menu: **/zeldaloot help** or **/zl help**
- Added the ability to toggle debug mode: **/zeldaloot debug** or **/zl debug**
- Added the ability to reset the config: **/zeldaloot reset** or **/zl reset**
- Added the ability to dump the config: **/zeldaloot dump** or **/zl dump**
- Fixed a bug where the sounds wouldn't play due to old config.

### Changes in 1.2.0
- Added more sounds from [ZeldaLoot Extended by LegendaryHero20](https://www.curseforge.com/wow/addons/zeldaloot-extended).
- Added the option to select which sound effect you want to use for each loot type.

### Changes in 1.1.1
- Fixed a bug where you weren't able to open the settings.

### Changes in 1.1.0
- You can now select which sound set to use for each of the item levels.
- You can also type **/zl** for the settings.
