{ lib, stdenv, makeWrapper, buildEnv
, breezy, coreutils, cvs, findutils, gawk, git, git-lfs, gnused, mercurial, nix, subversion
}:

let mkPrefetchScript = tool: src: deps:
  stdenv.mkDerivation {
    name = "nix-prefetch-${tool}";

    nativeBuildInputs = [ makeWrapper ];

    dontUnpack = true;

    installPhase = ''
      install -vD ${src} $out/bin/$name;
      wrapProgram $out/bin/$name \
        --prefix PATH : ${lib.makeBinPath (deps ++ [ gnused nix ])} \
        --set HOME /homeless-shelter
    '';

    preferLocalBuild = true;

    meta = with lib; {
      description = "Script used to obtain source hashes for fetch${tool}";
      maintainers = with maintainers; [ bennofs ];
      platforms = platforms.unix;
    };
  };
in rec {
  nix-prefetch-bzr = mkPrefetchScript "bzr" ./scripts/nix-prefetch-bzr [ breezy ];
  nix-prefetch-cvs = mkPrefetchScript "cvs" ./scripts/nix-prefetch-cvs [ cvs ];
  nix-prefetch-git = mkPrefetchScript "git" ./scripts/nix-prefetch-git [ coreutils findutils gawk git git-lfs ];
  nix-prefetch-hg  = mkPrefetchScript "hg"  ./scripts/nix-prefetch-hg [ mercurial ];
  nix-prefetch-svn = mkPrefetchScript "svn" ./scripts/nix-prefetch-svn [ subversion ];

  nix-prefetch-scripts = buildEnv {
    name = "nix-prefetch-scripts";

    paths = [ nix-prefetch-bzr nix-prefetch-cvs nix-prefetch-git nix-prefetch-hg nix-prefetch-svn ];

    meta = with lib; {
      description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
      maintainers = with maintainers; [ bennofs ];
      platforms = platforms.unix;
    };
  };
}
