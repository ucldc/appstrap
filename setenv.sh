if [[ -n "${DEBUG-}" ]]; then
  set -x
fi

for java_home in "${HOME}/pkg/java/sun-7" "${HOME}/java/java7" # last existing path wins
do
    if [[ -e "${java_home}" ]]; then 
        export JAVA_HOME=$java_home
    fi
done


#export JAVA_HOME=${HOME}/pkg/java/sun-6

# don't pick SUSE's java
unset JAVA_BINDIR
unset JAVA_ROOT
unset JDK_HOME
unset JRE_HOME

# unset build-dsc-solaris10 environment
unset CFLAGS
unset CPPFLAGS
unset LDFLAGS
unset LD_LIBRARY_PATH
unset LD_RUN_PATH
unset PERL5LIB
unset PREFIX

# restore default path on SUSE, this should/should this only run on /dsc/ stacks?
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:/usr/games:/usr/lib/mit/bin:/usr/lib/mit/sbin:$HOME/bin
#           /usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/tingle/bin # <-- Amazon Linux AMI path
#                         [^^^^^^^^^^^^^]  /bin and /usr/bin switched; sbin's, /opt/aws/ and $HOME
#                                          

# don't pick up SUSE's python
unset PYTHONPATH
unset PYTHONSTARTUP

export PATH=${HOME}/pkg/bin:${HOME}/pkg/sbin:${HOME}/pkg/lib/perl5/site_perl/bin:${JAVA_HOME}/bin:${PATH}
export MANPATH=${HOME}/pkg/man:/usr/local/man:/usr/local/share/man:/usr/share/man
