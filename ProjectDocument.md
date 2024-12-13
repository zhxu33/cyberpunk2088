# Cyberpunk 2088 #

## Introduction ##

Cyberpunk 2088 is a 2D infinite progression game set in a neon-drenched, dystopian city teetering on the edge of chaos. Players take on the role of "W," a fearless mercenary on a mission to overthrow the oppressive Arasaka Corporation, a megacorporation that has plunged society into despair. Combining high-octane combat, endless level progression, and strategic upgrades, the game offers an exhilarating journey through an ever-evolving cyberpunk world. The ultimate goal is to infiltrate Arasaka's towering fortress, a sprawling skyscraper dominating the city skyline. However, upon breaching its inner sanctum, players uncover an unsettling truth: the interior is an infinite, procedurally generated loop, reflecting Arasaka’s mastery over both technology and reality. With dynamic action and engaging enemies, Cyberpunk 2088 immerses players in a world where every battle pushes them closer to uncovering the secrets of a system built to control them. Will you break free or become another cog in the machine?

## Project Resources

1. [Web-playable version of your game.](https://zhxu33.itch.io/cyberpunk-2088)  
2. [Trailor](https://www.youtube.com/watch?v=RgVgY8-F4nA)  
3. [Press Kit](https://languid-capacity-e83.notion.site/Cyberpunk-2088-15b706d55ba380758870fa84dc694b72)  
4. [Group Project Google Drive Folder](https://drive.google.com/drive/folders/1R5iv0R0Rx2gkmcWxXha3Wvq6lbOll6oC?usp=drive_link).
    4.1 [Group Initial Plan](https://docs.google.com/document/d/1TuI_5MxxG3TNvrD7Z8iwSdKDze4Wr04ZUydlNR9okWQ/edit?usp=sharing).
    4.2 [Group Progress Report](https://docs.google.com/document/d/12pQWgevDNh7WiyPMqM3151Qtb58PCUFHTxBVsjFJRXc/edit?usp=sharing).
    4.3 [Tester Comments Image from Final Festival 5 game tester comments](https://drive.google.com/file/d/1tn4Yijyf3Z--mwvjm6qE0DpVtvh7e7A6/view?usp=sharing).
    4.4 [Tester Comments Image from Game Night](https://drive.google.com/file/d/1VrLXNo-Ml2-__yk4NkgFRX27WTnjZDqs/view?usp=sharing).
    4.5 [Game Night Attendence](https://drive.google.com/file/d/1ugxaDAAzInmYY1SF0_6bfvD0VU_44uEw/view?usp=sharing).


## Gameplay Explanation ##

**In this section, explain how the game should be played. Treat this as a manual within a game. Explaining the button mappings and the most optimal gameplay strategy is encouraged.**

**Cyberpunk 2088 is a 2D FPS shooting game that can be upgraded by fighting monsters.**

| Keyboard operation               | Key |
|:--------------------------------:|:-----:|
|Move Right                        |   D  |
|Move Left                         |   A | 
|Jump (contain double jump)        |   W & Space  | 
|Teleport                          |   R (hold)   | 
|Shooting                          |   Left mouse button  | 
|Melee attack                      |   Right mouse button | 

**Recommendation of Game playing**
As the player, you will see an NPC near the spawn location. At the beginning of the first level, you will have 100 coins to upgrade your skill at the NPC store and there are about 12 types of skills you can choose. As the designer, we prefer you to choose Movement speed. After upgrading, the next step is to explore the MAP. On the map, you will kill all the enemies that stop your way and they will drop coins to let you collect and upgrade. When you think you have enough coins, you can press "R" to teleport back to the first NPC you met at the beginning of the game. Then, it's time to upgrade other skills! We don't have any skills for healing the player, but you can collect the heart will might be dropped by enemies. When you explore the map, you will see some other NPC for you to upgrade your skills so DON'T WORRY! Then, when you finally reach the boss room. FIGHT IT and KILL it! Then, get into the portal and you will get into the next level of the game. The HP of the enemy and the damage will increase!! BE CAREFUL!

**THREE TYPES OF ENEMIES**
1. Self-destruct Slim (When you reach the range, they will chase you, and BOOM! PLEASE!! Playe safe and stay in the safe area)
2. Cyber Ninjia (They are samurai patrolling with electric light knives, be careful not to go near them because their knives will tear you to pieces）
3. Robot guard dog (Don't worry! They're good enough to stand still but they'll detect you at a distance and want you to fire a cannonball. It's a long way! Please take shelter in time!）

**TWO TYPES OF BOSS**


# Main Roles #

Your goal is to relate the work of your role and sub-role in terms of the content of the course. Please look at the role sections below for specific instructions for each role.

Below is a template for you to highlight items of your work. These provide the evidence needed for your work to be evaluated. Try to have at least four such descriptions. They will be assessed on the quality of the underlying system and how they are linked to course content. 

*Short Description* - Long description of your work item that includes how it is relevant to topics discussed in class. [link to evidence in your repository](https://github.com/dr-jam/ECS189L/edit/project-description/ProjectDocumentTemplate.md)

Here is an example:  
*Procedural Terrain* - The game's background consists of procedurally generated terrain produced with Perlin noise. The game can modify this terrain at run-time via a call to its script methods. The intent is to allow the player to modify the terrain. This system is based on the component design pattern and the procedural content generation portions of the course. [The PCG terrain generation script](https://github.com/dr-jam/CameraControlExercise/blob/513b927e87fc686fe627bf7d4ff6ff841cf34e9f/Obscura/Assets/Scripts/TerrainGenerator.cs#L6).

You should replay any **bold text** with your relevant information. Liberally use the template when necessary and appropriate.

## Producer

**Describe the steps you took in your role as producer. Typical items include group scheduling mechanisms, links to meeting notes, descriptions of team logistics problems with their resolution, project organization tools (e.g., timelines, dependency/task tracking, Gantt charts, etc.), and repository management methodology.**

## User Interface and Input

**Describe your user interface and how it relates to gameplay. This can be done via the template.**
**Describe the default input configuration.**

**Add an entry for each platform or input style your project supports.**

## Movement/Physics

**Describe the basics of movement and physics in your game. Is it the standard physics model? What did you change or modify? Did you make your movement scripts that do not use the physics system?**
We contain two essential folders in the script folder: character and command. They include the main movements and any other important physics of the game characters and enemies. 

**Movement is velocity-based, with separate horizontal and vertical components**
The character system implements:
* Left/right movement with constant velocity
* Jumping mechanics with initial jump velocity
* Double jump system based on upgrade levels
* Climbing mechanics on ladders
* A zero-velocity idle state

**As what we learned from the exercise 1 to exercise 3, our game uses Godot's standard physics model with some customization**
* It uses CharacterBody2D's built-in velocity and physics processing
* Maintains the standard gravity system (inherited from Character class)
* Uses the built-in floor detection for jump mechanics
* Employs the standard delta-time-based physics processing
**There are several custom modifications are implemented for the player (character)**
  * Custom movement speed system that scales with upgrades: `movement_speed = DEFAULT_MOVE_VELOCITY + Stats.upgrades["Movement Speed"]*20`
  * Modified jump velocity that scales with upgrades: `jump_velocity = DEFAULT_JUMP_VELOCITY - Stats.upgrades["Jump Power"]*25`
  *  Custom ladder physics that overrides vertical movement: `velocity.y = -movement_speed` when climbing
  * Custom double jump system that:
      * Tracks jump count
      * Only allows additional jumps when falling (velocity.y >= 0)
  * Limits jumps based on upgrade level: `jump_amount <= Stats.upgrades["Double Jump"]`
**In our custom movements scripts we use custom movement scripts through the command pattern and they still work within the physics systems:**
 * `MoveLeftCommand` and `MoveRightCommand` handle horizontal movement by directly setting velocity.x
 * `JumpCommand` controls vertical movement by setting velocity.y
 * `IdleCommand` handles stopping by zeroing horizontal velocity
 * The commands are bound and unbound through `bind_player_input_commands() and `unbind_player_input_commands()`

**All we did is like what we did in exercise 1**
**In addition, the enemy's movement and physical system are similar to what we did for the game character（player)**
**For the camera, we choose the very simplest one which is Exercise 2 Stage 1 - Position Lock. The camera will lock on the character and it is the best and easiest on to let the camera follow the player**
* In the `CameraController` Script, we extend `Camera2D` and the script creates a reference to the player character which is our player.
* The camera's behavior is straightforward - when the scene starts, it positions itself at the player's location through the `_ready()` function, and then continuously tracks the player's position every frame using the `_process()` function.
* 


## Animation and Visuals

1. [character & NPC](https://free-game-assets.itch.io/free-3-cyberpunk-sprites-pixel-art)                      
2. [Backgroud](https://free-game-assets.itch.io/free-city-backgrounds-pixel-art).                      
3. [Tileset](https://free-game-assets.itch.io/free-industrial-zone-tileset-pixel-art).      
4. [Protal](https://www.pngall.com/portal-png/download/33556/#google_vignette).                    
5. [Coins](https://www.flaticon.com/free-icon/coin_217802).                         
6. [Heart](https://reserve.freesvg.org/red-heart-with-black-outline).                      
7. [Weapons and Bullets](https://free-game-assets.itch.io/free-guns-for-cyberpunk-characters-pixel-art).|
**Describe how your work intersects with game feel, graphic design, and world-building. Include your visual style guide if one exists.**

## Game Logic

**Document the game states and game data you managed and the design patterns you used to complete your task.**

# Sub-Roles

## Audio

**List your assets, including their sources and licenses.**

**Describe the implementation of your audio system.**

**Document the sound style.** 

## Gameplay Testing

**Add a link to the full results of your gameplay tests.**

**Summarize the key findings from your gameplay tests.**

## Map Design/Map Mechanism

**Document how the narrative is present in the game via assets, gameplay systems, and gameplay.** 

## Press Kit and Trailer

**Include links to your presskit materials and trailer.**

**Describe how you showcased your work. How did you choose what to show in the trailer? Why did you choose your screenshots?**

## Game Feel and Polish

**Document what you added to and how you tweaked your game to improve its game feel.**
