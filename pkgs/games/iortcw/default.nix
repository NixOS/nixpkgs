{ buildEnv, callPackage, makeWrapper }:

let
  sp = callPackage ./sp.nix {};
<<<<<<< HEAD
  mp = sp.overrideAttrs (oldAttrs: {
    sourceRoot = "${oldAttrs.src.name}/MP";
=======
  mp = sp.overrideAttrs (oldAttrs: rec {
    sourceRoot = "source/MP";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  });
in buildEnv {
  name = "iortcw";

  paths = [ sp mp ];

  pathsToLink = [ "/opt" ];

  nativeBuildInputs = [ makeWrapper ];

  # so we can launch sp from mp game and vice versa
  postBuild = ''
    for i in `find -L $out/opt/iortcw -maxdepth 1 -type f -executable`; do
      makeWrapper $i $out/bin/`basename $i` --chdir "$out/opt/iortcw"
    done
  '';

  meta = sp.meta // {
    description = "Game engine for Return to Castle Wolfenstein";
  };
}
