{ runCommand }:

# Prints information about the state of the build environment for
# assistance debugging Hydra. Feel free to add anything you would find
# useful to this.
runCommand "build-environment-info" { } ''
  ulimit -a

  # Always fail so that this job can easily be restarted.
  exit 1
''
