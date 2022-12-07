# Installation

1. clone this repository into `~/.suturo`
2. add the line `source ~/.suturo/suturorc` to the end of your `.bashrc`
3. Optional: copy `~/.suturo/settings-default` to `~/.suturo/settings` and change the network_if to the interface used for working on the real robot.

## Optional: setup user-specific git configuration
- use `mkdir ~/.suturo/settings.d` to create the settings directory
- create a file called `gitconfig-$NAME.sh`, where `$NAME` is the name of the person
- export all variables you want to override in there, for example like this:
  ```sh
  # make sure to export the variables, otherwise git will NOT see them
  export GIT_AUTHOR_NAME="McModknower test"
  export GIT_AUTHOR_EMAIL="teetoll@t-online.de"
  export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa_mcmodknower"
  ```
