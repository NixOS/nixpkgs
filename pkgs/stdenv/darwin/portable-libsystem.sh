# Make /nix/store/...-libSystem “portable” for static built binaries.
# This just rewrites everything in $1/bin to use the
# /usr/lib/libSystem.B.dylib that is provided on every macOS system.

fixupOutputHooks+=('fixLibsystemRefs $prefix')

fixLibsystemRefs() {
  if [ -d "$1/bin" ]; then
      find "$1/bin" -type f -exec \
        @targetPrefix@install_name_tool -change @libsystem@ /usr/lib/libSystem.B.dylib {} \;
  fi
}
