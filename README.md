# Installation

1. clone this repository into `~/.suturo`,
   for exaple using `git clone https://github.com/McModknower/suturo-dotfiles.git ~/.suturo`  
   If your installation dir is different, you have to change the first line
   of the suturorc file to point to your installation dir.
2. add the line `source ~/.suturo/suturorc` to the end of your `.bashrc`
3. Optional: copy `~/.suturo/settings-default` to `~/.suturo/settings` and change the network_if to the interface used for working on the real robot.

## Optional: setup user-specific git configuration
- use `mkdir ~/.suturo/settings.d` to create the settings directory
- create a file called `gitconfig-$NAME.sh`, where `$NAME` is the name of the person
- export all variables you want to override in there, for example like this:
  ```sh
  # make sure to export the variables, otherwise git will NOT see them
  export GIT_AUTHOR_NAME="McModknower test"
  export GIT_AUTHOR_EMAIL="mcmodknower@example.com"
  export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
  export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa_mcmodknower"
  ```

# Features

## Modes
`sim_mode` and `hsrb_mode` commands to quickly setup `ROS_MASTER_URI` and `ROS_IP`.
These update the `ROS_IP` in case you switched network interfaces (wlan to cable, etc).
For that purpose, the network_if in the settings file is used.
The mode will also be written into `settings.d/rosmode`
and new shell sessions after setting the rosmode will use the new mode.

## Aliases
### Aliases for catkin tools
| Alias | Command                |
|-------|------------------------|
| src   | catkin source          |
| cb    | catkin build           |
| cbs   | cb && src              |
| ccbs  | catkin clean -y && cbs |
| ccb   | catkin clean -y && cb  |

## Git
### `git_ssh_repo`
The command `git_ssh_repo` changes the push url of a repository to an ssh url,
so you can push using an ssh key instead of username and password.
### User-Specific Git configuration
Since there are multiple people using the same user account on the suturo computers,
there is a way to have multiple ssh-key and git author configurations.
This is setup as described above in the Installation section.
If your gitconfig file is named `gitconfig-mcmodknower.sh` you can use
`git mcmodknower commit ...` and `git mcmodknower push` to use your git configuration.
this also works for all other git commands.
