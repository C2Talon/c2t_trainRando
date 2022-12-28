# c2t_trainRando

Warning: this script is defunct; there is no list provided for it to work from.

This script uses the crimbo training manual to teach the skill to a random person on the list found in `data/c2t_trainRandoTargets.txt`. If that random person already has the skill, it will just iterate through the list from that point until a valid target is found.

The list this script uses is no longer maintained and is empty here. To use this script, the `c2t_trainRandoTargets.txt` file would need to include a list of players to attempt to give the skill to, with each on their own line. How you populate that list is up to you.

## Installation

On the kolmafia gCLI:

`git checkout https://github.com/C2Talon/c2t_trainRando.git master`

## Usage

On the Kolmafia gCLI, it is simply:

`c2t_trainRando`

It can also be `import`ed into other scripts, which then the function `c2t_trainRando()` can be called.

