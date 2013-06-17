# stack_run.sh 
# functions to build out the stack based on commented spec files

stack_run_line() {
  # remove comments and clean whitespace from the input file
  local var=$@
  var=${var/\#*/}                        # remove comments
  # http://stackoverflow.com/a/3352015/1763984
  var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
  echo -n "$var"
}

stack_run_batch() {
  # stack_run_batch "command" file
  # will run the command for every line in the file
  # tries to ignore comments marked with `#` and blank links
  local command=$1
  local file=$2
  # http://stackoverflow.com/a/1521498/1763984
  while read p; do
    package=`stack_run_line "$p"`
    if [ "$package" ]; then                # skip blank lines
      $command $package
    fi
  done < $file
}
