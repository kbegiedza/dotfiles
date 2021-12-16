case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

forward_grafana() {
  kubectl config use-context $1 &&
  kubectl port-forward -n diagnostics svc/prometheus-grafana 8802:80
}

source ~/.bash_aliases
source ~/.bash_style