# c2t_trainRando

Uses the crimbo training manual to teach the skill to a random person on the list found in `data/c2t_trainRandoTargets.txt`. If that random person already has the skill, it will just iterate through the list from that point until a valid target is found.

The list this script uses is compiled from a publicly-available spreadsheet of those seeking the skills, and the list will be updated to match that spreadsheet at least once a day until 2023.

## Installation

On the kolmafia gCLI:

`git checkout https://github.com/C2Talon/c2t_trainRando.git master`

## Usage

On the Kolmafia gCLI, it is simply:

`c2t_trainRando`

It can also be `import`ed into other scripts, which then the function `c2t_trainRando()` can be called.

