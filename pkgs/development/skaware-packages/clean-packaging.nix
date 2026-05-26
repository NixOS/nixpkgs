# set of utilities that assure the cwd of a build
# is completely clean after the build, meaning all
# files were either discarded or moved to outputs.
# This ensures nothing is forgotten and new files
# are correctly handled on update.
{
  lib,
  stdenv,
  file,
  writeScript,
}:

let
  globWith = lib.concatMapStringsSep "\n";
  rmNoise = noiseGlobs: globWith (f: "rm -rf ${f}") noiseGlobs;
  mvDoc = docGlobs: globWith (f: ''mv ${f} "$DOCDIR" 2>/dev/null || true'') docGlobs;

  # Shell script that implements common move & remove actions
  # $1 is the doc directory (will be created).
  # Best used in conjunction with checkForRemainingFiles
  commonFileActions =
    {
      # list of fileglobs that are removed from the source dir
      noiseFiles,
      # files that are moved to the doc directory ($1)
      # TODO(Profpatsch): allow to set target dir with
      # { glob = …; to = "html" } (relative to docdir)
      docFiles,
    }:
    writeScript "common-file-actions.sh" ''
      #!${stdenv.shell}
      set -e
      DOCDIR="''${1?commonFileActions: DOCDIR as argv[1] required}"
      shopt -s globstar extglob nullglob
      mkdir -p "$DOCDIR"
      ${mvDoc docFiles}
      ${rmNoise noiseFiles}
    '';

  # Shell script to check whether the build directory is empty.
  # If there are still files remaining, exit 1 with a helpful
  # listing of all remaining files and their types.
  checkForRemainingFiles = writeScript "check-for-remaining-files.sh" ''
    #!${stdenv.shell}
    echo "Checking for remaining source files"
    rem=$(find -mindepth 1 -xtype f -print0 \
           | tee $TMP/remaining-files)
    if [[ "$rem" != "" ]]; then
      echo "ERROR: These files should be either moved or deleted:"
      cat $TMP/remaining-files | xargs -0 ${file}/bin/file
      exit 1
    fi
  '';

in
{
  inherit commonFileActions checkForRemainingFiles;
}
