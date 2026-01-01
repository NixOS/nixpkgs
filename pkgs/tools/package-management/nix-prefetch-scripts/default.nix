{
  lib,
  stdenv,
  makeWrapper,
  buildEnv,
<<<<<<< HEAD
  bashNonInteractive,
=======
  bash,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  breezy,
  cacert,
  coreutils,
  cvs,
  darcs,
  findutils,
  gawk,
  gitMinimal,
  git-lfs,
<<<<<<< HEAD
  gnugrep,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      buildInputs = [ bashNonInteractive ];
=======
      buildInputs = [ bash ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

      dontUnpack = true;

      installPhase = ''
        install -vD ${src} $out/bin/$name;
        wrapProgram $out/bin/$name \
<<<<<<< HEAD
          --prefix PATH : ${lib.makeBinPath (deps ++ [ coreutils ])} \
=======
          --prefix PATH : ${
            lib.makeBinPath (
              deps
              ++ [
                coreutils
                gnused
              ]
            )
          } \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
          --set HOME /homeless-shelter
      '';

      preferLocalBuild = true;

<<<<<<< HEAD
      meta = {
        description = "Script used to obtain source hashes for fetch${tool}";
        maintainers = with lib.maintainers; [ bennofs ];
        platforms = lib.platforms.unix;
=======
      meta = with lib; {
        description = "Script used to obtain source hashes for fetch${tool}";
        maintainers = with maintainers; [ bennofs ];
        platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    gnused
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];
  nix-prefetch-cvs = mkPrefetchScript "cvs" ../../../build-support/fetchcvs/nix-prefetch-cvs [ cvs ];
  nix-prefetch-darcs = mkPrefetchScript "darcs" ../../../build-support/fetchdarcs/nix-prefetch-darcs [
    darcs
    cacert
    gawk
    jq
  ];
  nix-prefetch-git = mkPrefetchScript "git" ../../../build-support/fetchgit/nix-prefetch-git [
    findutils
    gawk
    gitMinimal
    git-lfs
<<<<<<< HEAD
    gnused
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];
  nix-prefetch-hg = mkPrefetchScript "hg" ../../../build-support/fetchhg/nix-prefetch-hg [
    mercurial
  ];
  nix-prefetch-svn = mkPrefetchScript "svn" ../../../build-support/fetchsvn/nix-prefetch-svn [
<<<<<<< HEAD
    gnugrep
    gnused
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    subversion
  ];
  nix-prefetch-pijul = mkPrefetchScript "pijul" ../../../build-support/fetchpijul/nix-prefetch-pijul [
    gawk
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

<<<<<<< HEAD
    meta = {
      description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
      maintainers = with lib.maintainers; [ bennofs ];
      platforms = lib.platforms.unix;
=======
    meta = with lib; {
      description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
      maintainers = with maintainers; [ bennofs ];
      platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };
}
