# What is Require?
A custom module loader built to replace and extend the functionality of the default `require` global in Roblox. This has been a mini project I've had in mind for a while now and, after working with other languages and seeing how modules could be taken apart, decided to finally include this functionality into Roblox to help speed up the scripting workflow.


## License
See [LICENSE](https://github.com/cyrus01337/require/blob/main/LICENSE)


## Prerequisites
There is an approach that uses Git if your project is Git-oriented for simplicity, however, approaches still exist for non-Git and strictly Roblox Studio users as well. If your project is or going to be on Github, your only requirement will be [Git](https://git-scm.com/).


## Setup
- [For Git users](https://github.com/cyrus01337/require#Git)
- [For strictly Rojo users](https://github.com/cyrus01337/require#Rojo)
- [For strictly Roblox Studio users](https://github.com/cyrus01337/require#ROBLOX-Studio)


## Git
After you've cloned the repo, all you need to do is change directory to the location you want Require to be installed and run:
```sh
git submodule add https://github.com/cyrus01337/require.git Require
```

For those new to sub-modules, this clones the repo and creates the folder under the name Require (`git submodule add ... <url> Require`) then adds the sub-module as a dependency to your project. If you didn't already have a sub-module added before, a new `.gitsubmodules` file will appear at the root of your project that stores metadata for Git to use as CLI settings when manipulating (i.e. pulling, fetching) the repo. More info on Git sub-modules [here.](https://git-scm.com/book/en/v2/Git-Tools-Submodules)


## Rojo
Download the repo as shown in the diagram below then extract it where you would like to have it installed.
![Click "Code" then click Download ZIP](https://i.imgur.com/CoMPFJb.png)


## ROBLOX Studio
For Studio users, [go here](https://github.com/cyrus01337/require/blob/main/init.lua) or click the `init.lua` in the repo. Right-click the "Raw" button and save the link as a file, then go into Studio, right-click the instance you want to insert the script into, select "Insert from file..." and open the file you saved.


## Contributing
PRs welcome!
