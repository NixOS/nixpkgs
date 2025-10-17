{
  lib,
  stdenv,
  makeWrapper,
  buildEnv,
  bash,
  breezy,
  cacert,
  coreutils,
  cvs,
  darcs,
  findutils,
  gawk,
  gitMinimal,
  git-lfs,
  gnused,
  jq,
  mercurial,
  pijul,
  subversion,
}:

let
  mkPrefetchScript =
    tool: src: deps:
    stdenv.mkDerivation {
      name = "nix-prefetch-${tool}";

      strictDeps = true;
      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ bash ];

      dontUnpack = true;

      installPhase = ''
        install -vD ${src} $out/bin/$name;
        wrapProgram $out/bin/$name \
          --prefix PATH : ${
            lib.makeBinPath (
              deps
              ++ [
                coreutils
                gnused
              ]
            )
          } \
          --set HOME /homeless-shelter
      '';

      preferLocalBuild = true;

      meta = with lib; {
        description = "Script used to obtain source hashes for fetch${tool}";
        maintainers = with maintainers; [ bennofs ];
        platforms = platforms.unix;
        mainProgram = "nix-prefetch-${tool}";
      };
    };
in
rec {
  # No explicit dependency on Nix, as these can be used inside builders,
  # and thus will cause dependency loops. When used _outside_ builders,
  # we expect people to have a Nix implementation available ambiently.
  nix-prefetch-bzr = mkPrefetchScript "bzr" ../../../build-support/fetchbzr/nix-prefetch-bzr [
    breezy
  ];
  nix-prefetch-cvs = mkPrefetchScript "cvs" ../../../build-support/fetchcvs/nix-prefetch-cvs [ cvs ];
  nix-prefetch-darcs = mkPrefetchScript "darcs" ../../../build-support/fetchdarcs/nix-prefetch-darcs [
    darcs
    cacert
    jq
  ];
  nix-prefetch-git = mkPrefetchScript "git" ../../../build-support/fetchgit/nix-prefetch-git [
    findutils
    gawk
    gitMinimal
    git-lfs
  ];
  nix-prefetch-hg = mkPrefetchScript "hg" ../../../build-support/fetchhg/nix-prefetch-hg [
    mercurial
  ];
  nix-prefetch-svn = mkPrefetchScript "svn" ../../../build-support/fetchsvn/nix-prefetch-svn [
    subversion
  ];
  nix-prefetch-pijul = mkPrefetchScript "pijul" ../../../build-support/fetchpijul/nix-prefetch-pijul [
    pijul
    cacert
    jq
  ];

  nix-prefetch-scripts = buildEnv {
    name = "nix-prefetch-scripts";

    paths = [
      nix-prefetch-bzr
      nix-prefetch-cvs
      nix-prefetch-darcs
      nix-prefetch-git
      nix-prefetch-hg
      nix-prefetch-svn
      nix-prefetch-pijul
    ];

    meta = with lib; {
      description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
      maintainers = with maintainers; [ bennofs ];
      platforms = platforms.unix;
    };
  };
}
