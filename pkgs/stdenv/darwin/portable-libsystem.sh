# Make /nix/store/...-libSystem “portable” for static built binaries.
# This just rewrites everything in $1/bin to use the
# /usr/lib/libSystem.B.dylib that is provided on every macOS system.

fixupOutputHooks+=('fixLibsystemRefs $prefix')

fixLibsystemRefs() {
  if [ -d "$1/bin" ]; then
<<<<<<< HEAD
      find "$1/bin" -type f -exec \
        @targetPrefix@install_name_tool -change @libsystem@ /usr/lib/libSystem.B.dylib {} \;
=======
      find "$1/bin" -exec \
        install_name_tool -change @libsystem@ /usr/lib/libSystem.B.dylib {} \;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  fi
}
