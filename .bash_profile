export PATH="$HOME/bin:$PATH";

function enable_ssh_for_vscode() {
    if [ -z "$SSH_AUTH_SOCK" ]; then
    # Check for a currently running instance of the agent
    RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
    if [ "$RUNNING_AGENT" = "0" ]; then
            # Launch a new instance of the agent
            ssh-agent -s &> $HOME/.ssh/ssh-agent
    fi
    eval `cat $HOME/.ssh/ssh-agent`
    fi
}

enable_ssh_for_vscode

source ~/.bashrc