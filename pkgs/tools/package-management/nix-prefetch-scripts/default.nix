{
  lib,
  breezy,
  buildEnv,
  coreutils,
  cvs,
  findutils,
  gawk,
  git,
  git-lfs,
  gnused,
  makeWrapper,
  mercurial,
  nix,
  stdenv,
  subversion,
}:

let
  mkPrefetchScript =
    tool: src: deps:
    stdenv.mkDerivation {
      pname = "nix-prefetch-${tool}";
      version = "0";

      nativeBuildInputs = [ makeWrapper ];

      dontUnpack = true;

      preferLocalBuild = true;

      installPhase = ''
        install -vD ${src} $out/bin/$name;
        wrapProgram $out/bin/$name \
          --prefix PATH : ${
            lib.makeBinPath (
              deps
              ++ [
                gnused
                nix
              ]
            )
          } \
          --set HOME /homeless-shelter
      '';

      meta = {
        description = "Script used to obtain source hashes for fetch${tool}";
        maintainers = with lib.maintainers; [ bennofs ];
        platforms = lib.platforms.unix;
      };
    };
in
rec {
  nix-prefetch-bzr = mkPrefetchScript "bzr" ./scripts/nix-prefetch-bzr [ breezy ];
  nix-prefetch-cvs = mkPrefetchScript "cvs" ./scripts/nix-prefetch-cvs [ cvs ];
  nix-prefetch-git = mkPrefetchScript "git" ./scripts/nix-prefetch-git [
    coreutils
    findutils
    gawk
    git
    git-lfs
  ];
  nix-prefetch-hg = mkPrefetchScript "hg" ./scripts/nix-prefetch-hg [ mercurial ];
  nix-prefetch-svn = mkPrefetchScript "svn" ./scripts/nix-prefetch-svn [ subversion ];

  nix-prefetch-scripts = buildEnv {
    name = "nix-prefetch-scripts";

    paths = [
      nix-prefetch-bzr
      nix-prefetch-cvs
      nix-prefetch-git
      nix-prefetch-hg
      nix-prefetch-svn
    ];

    meta = {
      description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
      maintainers = with lib.maintainers; [ bennofs ];
      platforms = lib.platforms.unix;
    };
  };
}
