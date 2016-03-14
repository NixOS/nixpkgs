{ stdenv, makeWrapper, buildEnv,
  git, subversion, mercurial, bazaar, cvs, unzip, curl, gnused, coreutils, nix
}:

let mkPrefetchScript = tool: src: deps:
  stdenv.mkDerivation {
    name = "nix-prefetch-${tool}";

    buildInputs = [ makeWrapper ];

    phases = [ "installPhase" "fixupPhase" ];
    installPhase = ''
      mkdir -p $out/bin

      local wrapArgs=""
      cp ${src} $out/bin/$name;
      for dep in ${stdenv.lib.concatStringsSep " " deps}; do
        wrapArgs="$wrapArgs --prefix PATH : $dep/bin"
      done
      wrapArgs="$wrapArgs --prefix PATH : ${gnused}/bin"
      wrapArgs="$wrapArgs --prefix PATH : ${nix}/bin" # For nix-hash
      wrapArgs="$wrapArgs --set HOME : /homeless-shelter"
      wrapProgram $out/bin/$name $wrapArgs
    '';

    preferLocalBuild = true;

    meta = with stdenv.lib; {
      description = "Script used to obtain source hashes for fetch${tool}";
      maintainers = with maintainers; [ bennofs ];
      platforms = stdenv.lib.platforms.unix;
    };
  };
in rec {
  nix-prefetch-bzr = mkPrefetchScript "bzr" ../../../build-support/fetchbzr/nix-prefetch-bzr [bazaar];
  nix-prefetch-cvs = mkPrefetchScript "cvs" ../../../build-support/fetchcvs/nix-prefetch-cvs [cvs];
  nix-prefetch-git = mkPrefetchScript "git" ../../../build-support/fetchgit/nix-prefetch-git [git coreutils];
  nix-prefetch-hg  = mkPrefetchScript "hg"  ../../../build-support/fetchhg/nix-prefetch-hg   [mercurial];
  nix-prefetch-svn = mkPrefetchScript "svn" ../../../build-support/fetchsvn/nix-prefetch-svn [subversion.out];
  nix-prefetch-zip = mkPrefetchScript "zip" ../../../build-support/fetchzip/nix-prefetch-zip [unzip curl.bin];

  nix-prefetch-scripts = buildEnv {
    name = "nix-prefetch-scripts";

    paths = [ nix-prefetch-bzr nix-prefetch-cvs nix-prefetch-git nix-prefetch-hg nix-prefetch-svn nix-prefetch-zip ];

    meta = with stdenv.lib; {
      description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
      maintainers = with maintainers; [ bennofs ];
      platforms = stdenv.lib.platforms.unix;
    };
  };
}
