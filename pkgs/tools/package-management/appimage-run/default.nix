{ stdenv, writeScript, buildFHSUserEnv, coreutils, file, libarchive, runtimeShell
, extraPkgs ? pkgs: [], appimageTools }:

let
  fhsArgs = appimageTools.defaultFhsEnvArgs;
in buildFHSUserEnv (fhsArgs // {
  name = "appimage-run";

  targetPkgs = pkgs: fhsArgs.targetPkgs pkgs ++ extraPkgs pkgs;

  runScript = writeScript "appimage-exec" ''
    #!${runtimeShell}
    if [ $# -eq 0 ]; then 
      echo "Usage: $0 FILE [OPTION...]"
      echo
      echo 'Options are passed on to the appimage.'
      echo "If you want to execute a custom command in the appimage's environment, set the APPIMAGE_DEBUG_EXEC environment variable."
      exit 1
    fi
    APPIMAGE="$(realpath "$1")"
    shift

    if [ ! -x "$APPIMAGE" ]; then
      echo "fatal: $APPIMAGE is not executable"
      exit 1
    fi

    SHA256="$(${coreutils}/bin/sha256sum "$APPIMAGE" | cut -d ' ' -f 1)"
    SQUASHFS_ROOT="''${XDG_CACHE_HOME:-$HOME/.cache}/appimage-run/$SHA256/"
    mkdir -p "$SQUASHFS_ROOT"

    export APPDIR="$SQUASHFS_ROOT/squashfs-root"
    if [ ! -x "$APPDIR" ]; then
      cd "$SQUASHFS_ROOT"

      if ${file}/bin/file --mime-type --brief --keep-going "$APPIMAGE" | grep -q iso; then
        # is type-1 appimage
        mkdir "$APPDIR"
        ${libarchive}/bin/bsdtar -x -C "$APPDIR" -f "$APPIMAGE"
      else
        # is type-2 appimage
        "$APPIMAGE" --appimage-extract 2>/dev/null
      fi
    fi

    cd "$APPDIR"
    export PATH="$PATH:$PWD/usr/bin"
    export APPIMAGE_SILENT_INSTALL=1

    if [ -n "$APPIMAGE_DEBUG_EXEC" ]; then
      exec "$APPIMAGE_DEBUG_EXEC"
    fi

    exec ./AppRun "$@"
  '';
})
