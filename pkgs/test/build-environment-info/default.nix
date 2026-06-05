{
  lib,
  stdenv,
  runCommand,
  getent,
  xcbuild,
}:

# Prints information about the state of the build environment for
# assistance debugging Hydra. Feel free to add anything you would find
# useful to this.
runCommand "build-environment-info"
  {
    nativeBuildInputs = [ getent ] ++ lib.optionals stdenv.buildPlatform.isDarwin [ xcbuild ];
  }
  ''
    # It’s useful to get more info even if a command fails.
    set +e

    run() {
      echoCmd : "$@"
      "$@"
    }

    run uname -a

    ${lib.optionalString stdenv.buildPlatform.isDarwin ''
      run env SYSTEM_VERSION_COMPAT=0 plutil -p /System/Library/CoreServices/SystemVersion.plist
    ''}

    run id

    run getent passwd "$(id -un)"

    run ulimit -a

    # Always fail so that this job can easily be restarted.
    run exit 1
  ''
