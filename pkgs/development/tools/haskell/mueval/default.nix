{ lib, stdenv, makeWrapper, haskellPackages, packages ? (pkgs: [])
}:

let defaultPkgs = pkgs: [ pkgs.show
                          pkgs.simple-reflect
                          pkgs.QuickCheck
                          pkgs.mtl
                        ];
    env = haskellPackages.ghcWithPackages
           (pkgs: defaultPkgs pkgs ++ packages pkgs);

in stdenv.mkDerivation {
  name = "mueval-env";

  inherit (haskellPackages) mueval;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin

    makeWrapper $mueval/bin/mueval $out/bin/mueval \
      --set "NIX_GHC_LIBDIR" "$(${lib.getExe' env "ghc"} --print-libdir)"

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    [[ $($out/bin/mueval -e 42) == 42 ]]
  '';

  passthru = { inherit defaultPkgs; };
  meta.mainProgram = "mueval";
}
