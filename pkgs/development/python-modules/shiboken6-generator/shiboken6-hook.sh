# shellcheck shell=bash
# Variables we use here are set by the stdenv, no use complaining about them
# shellcheck disable=SC2164

shibokenEnvHook() {
  if [ -d "$1/share/PySide6/typesystems" ]; then
    addToSearchPath NIXPKGS_SHIBOKEN6_TYPESYSTEMS_PATH "$1/share/PySide6/typesystems"
  fi
  if [ -d "$1/include/PySide6" ]; then
    for i in "$1/include/PySide6/"*; do
      # horrible hack, see https://github.com/KDE/extra-cmake-modules/blob/bbbaae0dbbbea3a283ba45b00dd10fb0d7b631d9/modules/ECMGeneratePythonBindings.cmake#L84
      if [ -d "$i" ]; then
        export NIX_CFLAGS_COMPILE+=" -isystem $i"
      fi
    done
  fi
}
addEnvHooks "$targetOffset" shibokenEnvHook
