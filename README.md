**Repository of all small scripts I've made for using with animating stuff in Garry's Mod, Source Filmmaker, and video editing in Blender.**<br/>

# GARRYS MOD SCRIPTS:

Collection of small lua scripts that may come in handy for Garry's Mod animation.
<br/><br/>

## Advanced Camera Manipulator tool

Adds an "AdvCam Manipulator" tool that allows you to move Advanced Cameras and Soft Lamps by attaching them to yourself and moving with you, also allows to teleport yourself to the entity's position or its offset.

This tool is [uploaded on steam workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=2787625185)

[![Watch the YouTube video](https://img.youtube.com/vi/SMtjvSXIxEc/0.jpg)](https://www.youtube.com/watch?v=SMtjvSXIxEc)

<br/><br/>

## Fakedepth post processing effect

Edit of [depth shader addon](https://steamcommunity.com/sharedfiles/filedetails/?id=2805432246) by ilikecreepers
Allows to make depth render like effect, which could be useful for adding fog or DOF stuff in post editing. Edit allows this shader to work with skyboxes, makes it so render happens only once, so it doesn't get updated in realtime to save on resources, and has an option to add 3rd plane between original ones and color it.

[![Watch the YouTube video](https://img.youtube.com/vi/UaCVbICWNgA/0.jpg)](https://www.youtube.com/watch?v=UaCVbICWNgA)

<br/><br/>

## Light Origin Tool + Turn into Dynamic Prop Tool

Allows you to easily set lighting origin for ragdolls and dynamic props (Works even for entity's bonemerged stuffs. Doesn't work on physics props).

This tool is [uploaded on steam workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=2591866528)

[![Watch the YouTube video](https://img.youtube.com/vi/dNIv49caXlM/0.jpg)](https://www.youtube.com/watch?v=dNIv49caXlM)

[![Watch the YouTube video](https://img.youtube.com/vi/q_lFPTFm9GI/0.jpg)](https://www.youtube.com/watch?v=q_lFPTFm9GI)

<br/><br/>

## Lightbounce script + macro

Overcomplicated macro for Pulover's Macro Creator that would allow to automate taking Soft Lamp's lightbounce passes for Stop Motion Helper animations and a little lua script to get a mark on your HUD, which is meant Macro's screen detection to be able to tell when rendering is done. Comes with a Wiremod Expression 2 chip for teleporting player to the Soft Lamp's position and angles.

[![Watch the YouTube video](https://img.youtube.com/vi/4AetyXCdy_Y/0.jpg)](https://youtu.be/4AetyXCdy_Y?t=235)

<br/><br/>

## Script for manipulating specific eye shader's eye dilation

LUA  script that works for specific .vmt eye materials that allows you to manipulate their "dilation" through console. As an example, uses edited eye textures from [Chonch's upscaled eye pack](https://steamcommunity.com/sharedfiles/filedetails/?id=1742006887)

[![Watch the YouTube video](https://img.youtube.com/vi/4AetyXCdy_Y/0.jpg)](https://youtu.be/4AetyXCdy_Y?t=419)

<br/><br/>

## "Macro Replacement" Script

Script that adds "Macro Replacer" tab under "Peak Incompetence" category in gmod's utilities menu, that allows you to run console commands on loop with specific delays. Primary function for it is to run screenshot commands and advance SMH's animation by a frame, basically what smh_makejpeg does, but more customizable. Pairs quite well with material manipulation script below.

Currently it has a bug with UI that seems to happen if you click on the text entry box and click on the macro replacer tab.

[![Watch the YouTube video](https://img.youtube.com/vi/YQUmgGY1Pds/0.jpg)](https://youtu.be/YQUmgGY1Pds)

<br/><br/>

## Material manipulation script for Stop Motion Helper

Script which is meant to help out with the screenshot based rendering in stop motion helper, which allows playback of specific animated materials that were setup to work with the script through console. Also comes with a macro for Pulover's Macro Creator, as it doesn't work with Stop Motion Helper's own makescreenshot commands.

[![Watch the YouTube video](https://img.youtube.com/vi/xbLaRaxnG0U/0.jpg)](https://youtu.be/xbLaRaxnG0U)

[![Watch the YouTube video](https://img.youtube.com/vi/i4THjugoOUg/0.jpg)](https://youtu.be/i4THjugoOUg)

<br/><br/>

## Ragdoll Weight Tool

Tool that allows to set weight for individual bones on ragdolls, or set weight to specific numbers for all ragdoll bones. Primarily made this to allow to stretch ragdolls more, as setting it to about more than 30kg on bones that had "snap back" issue prevents them from doing that.

This tool is [uploaded on steam workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=2888247176)

[![Watch the YouTube video](https://img.youtube.com/vi/VGACqXq45q8/0.jpg)](https://youtu.be/VGACqXq45q8)

<br/><br/>

## Ragdoll Unstretch

Tool that is based on Standing Pose Tool, allows you to selectively return ragdoll's bones to "normal" positions. It is primarily meant to be used with [Ragdoll Stretch Tool](https://steamcommunity.com/sharedfiles/filedetails/?id=529986984&searchtext)

This tool is [uploaded on steam workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=2587143550)

[![Watch the YouTube video](https://img.youtube.com/vi/yf2g6Mihhe4/0.jpg)](https://youtu.be/yf2g6Mihhe4)

<br/><br/>

## Static Prop Replacer

LUA script that is meant to spawn prop_dynamics in place of map's prop_static entities, it is meant to work together with "blackify" script. Uses [NikNaks library](https://steamcommunity.com/sharedfiles/filedetails/?id=2861839844)

Console commands:
peak_sprep_replace - Spawns in prop_dynamics from the map you're on and hides static props, if replacer props were already spawned then it'll clear them and show static props

peak_sprep_replacefromfile [.txt with prop data] - Spawns in prop_dynamic from a json file that's stored in data/propreplace folder, if replacer props were already spawned then it'll clear them and show static props

peak_sprep_makepropdata - Takes static prop data from the map you're on and creates a json file in data/propreplace folder, this is primarily meant to be used as a way to edit out some of the static props, like if some props have to be removed

Has an older version with a python script made by Awsum N00b which extracts static prop data from map decompiles and turns them into files that the script uses.
>[!NOTE]
>[Gmod Light / Environment Editor](https://steamcommunity.com/sharedfiles/filedetails/?id=2779451924) can be a simpler to use alternative if you just want to get rid of the map's lighting, which also can remove baked lighting from static props, so you don't need to use blackify or this thing

[![Watch the YouTube video](https://img.youtube.com/vi/2DhWY4V_yqQ/0.jpg)](https://youtu.be/2DhWY4V_yqQ)

[![Watch the YouTube video](https://img.youtube.com/vi/7UQ_ie95Dl0/0.jpg)](https://youtu.be/7UQ_ie95Dl0)

<br/><br/>

## Very small scripts

Various old scripts I have that are meant to be run through lua_run or lua_run_cl console commands:

### Chatty: 
Allows you to mimic chat messages

### Soft lamps grabber (clientside): 
Finds all soft lamps and opens their properties menu. 
> [!NOTE]
> Newer Soft Lamp version allows to do basically the same now, so this is outdated

<br/>

--------

<br/>

# BLENDER ADDONS

I've also started making some small Python scripts for Blender, that allow me to speed up my video creation process in VSE:

<br/><br/>

## Fade in/out script

Blender already has a feature to automatically do fade in and out on VSE strips, though mine allows to set fade in/out time in frames, and also offset it by a set amount of frames. Quite niche.

<br/><br/>

## "Text Timer" script

This is meant to work with Text strips, it will set their duration to about the time it should take to read out that text. It is possible to set time it takes per word, per "sentence" (will add time for every . ! ? that's not at the end of the text) and per commma that's not at the end of the sentence. By default it uses 0.3 seconds per word, and 0.1 seconds per sentences and commas. 0.3 seconds per word is used based on an assumption that average person reads 200 words per minute, so 200/60 = ~3,33 words per second, and 1/3,33 = 0,3003 seconds per word.

<br/>

--------

<br/>

# SFM

Python scripts for Source Filmmaker, which I don't use often, but sometmes mess around with out of interest.

<br/><br/>

## Rig controls filler

Script that automatically "fills in" rig controls to any bones on a model, primarily meant as a way to reduce the lag that occurs when trying to move unrigged bones with rig_biped_simple applied
