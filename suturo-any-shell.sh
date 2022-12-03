set_ros_ip(){
    TARGET_IP=$(LANG=C /sbin/ip address show $network_if | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
    if [ -z "$TARGET_IP" ] ; then
	echo "ROS_IP not set."
    else
	export ROS_IP=$TARGET_IP
    fi
}

export ROS_HOME=~/.ros

alias sim_mode='export ROS_MASTER_URI=http://localhost:11311;set_ros_ip'
alias hsrb_mode='export ROS_MASTER_URI=http://hsrb.local:11311;set_ros_ip'

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
