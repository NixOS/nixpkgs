{ buildEnv, callPackage, makeWrapper }:

let
  sp = callPackage ./sp.nix {};
  mp = sp.overrideAttrs (oldAttrs: rec {
    sourceRoot = "source/MP";
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
