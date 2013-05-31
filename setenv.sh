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
