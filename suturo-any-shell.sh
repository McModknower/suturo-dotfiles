set_ros_ip(){
    for i in "${network_if[@]}"; do
	TARGET_IP=$(LANG=C /sbin/ip address show $i | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
	if [ -z "$TARGET_IP" ] ; then
	    echo "IP not set for $i, testing next interface."
	else
	    export ROS_IP=$TARGET_IP
	    break;
	fi
    done
    if [ -z "$TARGET_IP" ] ; then
	echo "ROS_IP not set, no interface with valid ip found"
    fi
}

load_ros_mode(){
    local MODE=localhost
    local ROS_MODE_FILE="$HOME/.suturo/settings.d/rosmode"
    if [ -r "$ROS_MODE_FILE" ]; then
	MODE="$(cat "$ROS_MODE_FILE")"
    fi
    if [ "$MODE" = "localhost" ] || [ "$MODE" = "hsrb.local" ]; then
	export ROS_MASTER_URI="http://${MODE}:11311"
	ROS_MODE_NAME="$MODE"
	set_ros_ip
	echo "Ros mode is $MODE"
    fi
}

set_ros_mode(){
    mkdir -p "$HOME/.suturo/settings.d/"
    echo "$1" > "$HOME/.suturo/settings.d/rosmode"
    load_ros_mode
}

export ROS_HOME=~/.ros

load_ros_mode

alias sim_mode='set_ros_mode localhost'
alias hsrb_mode='set_ros_mode hsrb.local'

. "$(catkin locate --shell-verbs)"

alias src="catkin source"
alias cb="catkin build"
alias cbs="cb && src"
alias ccbs="catkin clean -y && cbs"
alias ccb="catkin clean -y && cb"

alias percsrc='source ~/SUTURO/SUTURO_WSS/perception_ws/devel/setup.$SOURCING_SHELL'
alias plansrc='source ~/SUTURO/SUTURO_WSS/planning_ws/devel/setup.$SOURCING_SHELL'
alias knowsrc='source ~/SUTURO/SUTURO_WSS/knowledge_ws/devel/setup.$SOURCING_SHELL'
alias manisrc='source ~/SUTURO/SUTURO_WSS/manipulation_ws/devel/setup.$SOURCING_SHELL'

# Make sure that the git command is only set the first time.
# ZSH would otherwise return the function when sourcing a second time
if [ -z "$SUTURO_GIT_COMMAND" ]; then
    SUTURO_GIT_COMMAND="$(which git)"
fi

git() {
    local NAME="$1"
    # use the .sh file ending so editors automatically apply syntax highlighting
    local SUTURO_CONFIG_FILE="$HOME/.suturo/settings.d/gitconfig-$NAME.sh"
    # if NAME is not empty and the file exists
    if [ -n "$NAME" ] && [ -r "$SUTURO_CONFIG_FILE" ]; then
	# remove NAME from the list of parameters
	shift 1
	# spawn a subshell so the environment variables are not persisted.
	# "$@" expands to all positional parameters, as seperate words.
	(source "$SUTURO_CONFIG_FILE" && "$SUTURO_GIT_COMMAND" "$@")
    else
	"$SUTURO_GIT_COMMAND" "$@"
    fi
}

git_ssh_repo(){
    local URL="$(git remote get-url origin)"
    if echo "$URL" | grep -vqE '^https'; then
	echo "This repo is not using an https clone url, aborting."
    else
	# https://github.com/SUTURO/suturo_knowledge.git
	# git@github.com:SUTURO/suturo_knowledge.git
	URL="$(echo "$URL" | sed -e 's/^https:\/\//git@/;s/\//:/')"
	git remote set-url --push origin "$URL"
	echo "Changed push url to $URL"
    fi
}

git_https_repo(){
    local URL="$(git remote get-url origin)"
    if echo "$URL" | grep -vqE '^git@'; then
	echo "This repo is not using an ssh clone url, aborting."
    else
	# git@github.com:SUTURO/suturo_knowledge.git
	# https://github.com/SUTURO/suturo_knowledge.git
	NEW_URL="$(echo "$URL" | sed -e 's/:/\//;s/^git@/https:\/\//')"
	git remote set-url origin "$NEW_URL"
	git remote set-url --push origin "$URL"
	echo "Changed pull url to $NEW_URL"
    fi
}


# setting the prompt
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
show_ros_mode() {
	if [ -n "$ROS_MODE_NAME" ]; then
		echo "($ROS_MODE_NAME)"
	fi
}

# copied from default .bashrc, checks for colored terminals
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
	# the colors need to be inserted here and not later, that results in the '"COLOR"' sequences in between the rest.
	PS1='${debian_chroot:+($debian_chroot)}'"${COLOR_GREEN}${PROMT_USER}"'@'"${PROMT_HOST}${COLOR_WHITE}"':'"${COLOR_BLUE}${PROMT_WORKDIR}${COLOR_RED}"'$(parse_git_branch)'"${COLOR_YELLOW}"'$(show_ros_mode)'"${COLOR_WHITE}"'\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)$(show_ros_mode)\$ '
fi
unset color_prompt force_color_prompt
