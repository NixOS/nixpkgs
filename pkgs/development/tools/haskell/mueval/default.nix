{ stdenv, makeWrapper, haskellngPackages, packages ? (pkgs: [])
}:

let defaultPkgs = pkgs: [ pkgs.show
                          pkgs.simple-reflect
                          pkgs.QuickCheck
                          pkgs.mtl
                        ];
    env = haskellngPackages.ghcWithPackages
           (pkgs: defaultPkgs pkgs ++ packages pkgs);
    libDir = "${env}/lib/ghc-${env.version}";

in stdenv.mkDerivation {
  name = "mueval-env";

  inherit (haskellngPackages) mueval;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin

    makeWrapper $mueval/bin/mueval $out/bin/mueval \
      --prefix PATH ":" "$out/bin"

    makeWrapper $mueval/bin/mueval-core $out/bin/mueval \
      --set "NIX_GHC_LIBDIR" "${libDir}"

  '';

  passthru = { inherit defaultPkgs; };
}
