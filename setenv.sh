
# there is no $HOME in monit...
USER=$(/usr/bin/whoami) # http://codeblog.vurdalakov.net/2010/12/how-to-get-current-user-name-in-bash.html
HOME=$(getent passwd $USER | cut -d: -f6) # http://stackoverflow.com/a/7359006/1763984

export JAVA_HOME=${HOME}/pkg/java/sun-7
#export JAVA_HOME=${HOME}/pkg/java/sun-6

# don't pick SUSE's java
unset JAVA_BINDIR
unset JAVA_ROOT
unset JDK_HOME
unset JRE_HOME

# don't pick up SUSE's python
unset PYTHONPATH
unset PYTHONSTARTUP

export PATH=${HOME}/pkg/bin:${HOME}/pkg/sbin:${JAVA_HOME}/bin:${PATH}
export MANPATH=${HOME}/pkg/man
