if [[ -n "${DEBUG-}" ]]; then
  set -x
fi

export PATH=${PATH}:${HOME}/pkg/bin:${HOME}/pkg/sbin:${HOME}/pkg/lib/perl5/site_perl/bin
export MANPATH=${HOME}/pkg/man:/usr/local/man:/usr/local/share/man:/usr/share/man
export LD_LIBRARY_PATH=${HOME}/pkg/lib
