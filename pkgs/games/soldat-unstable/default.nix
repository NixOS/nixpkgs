{ lib, stdenv, fetchFromGitHub, fetchpatch, fpc, zip, makeWrapper
, SDL2, freetype, physfs, openal, gamenetworkingsockets
, xorg, autoPatchelfHook
}:

let
  base = stdenv.mkDerivation rec {
    pname = "soldat-base";
    version = "unstable-2020-11-26";

    src = fetchFromGitHub {
      name = "base";
      owner = "Soldat";
      repo = "base";
      rev = "e5f9c35ec12562595b248a7a921dd3458b36b605";
      sha256 = "0qg0p2adb5v6di44iqczswldhypdqvn1nl96vxkfkxdg9i8x90w3";
    };

    nativeBuildInputs = [ zip ];

    buildPhase = ''
      sh create_smod.sh
    '';

    installPhase = ''
      install -Dm644 soldat.smod -t $out/share/soldat
      install -Dm644 client/play-regular.ttf -t $out/share/soldat
    '';

    meta = with lib; {
      description = "Soldat's base game content";
      license = licenses.cc-by-40;
      platforms = platforms.all;
      inherit (src.meta) homepage;
    };
  };

in

stdenv.mkDerivation rec {
  pname = "soldat";
  version = "unstable-2021-02-09";

  src = fetchFromGitHub {
    name = "soldat";
    owner = "Soldat";
    repo = "soldat";
    rev = "c304c3912ca7a88461970a859049d217a44c6375";
    sha256 = "09sl2zybfcmnl2n3qghp0gylmr71y01534l6nq0y9llbdy0bf306";
  };

  nativeBuildInputs = [ fpc makeWrapper autoPatchelfHook ];

  buildInputs = [ SDL2 freetype physfs openal gamenetworkingsockets ];
  runtimeDependencies = [ xorg.libX11 ];

  patches = [
    # fix an argument parsing issue which prevents
    # us from passing nix store paths to soldat
    (fetchpatch {
      url = "https://github.com/sternenseemann/soldat/commit/9f7687430f5fe142c563b877d2206f5c9bbd5ca0.patch";
      sha256 = "0wsrazb36i7v4idg06jlzfhqwf56q9szzz7jp5cg4wsvcky3wajf";
    })
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p client/build server/build

    # build .so from stb headers
    pushd client/libs/stb
    make
    popd

    # build client
    pushd client
    make mode=release
    popd

    # build server
    pushd server
    make mode=release
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 client/libs/stb/libstb.so -t $out/lib
    install -Dm755 client/build/soldat_* $out/bin/soldat
    install -Dm755 server/build/soldatserver_* $out/bin/soldatserver

    # make sure soldat{,server} find their game archive,
    # let them write their state and configuration files
    # to $XDG_CONFIG_HOME/soldat/soldat{,server} unless
    # the user specifies otherwise.
    for p in $out/bin/soldatserver $out/bin/soldat; do
      configDir="\''${XDG_CONFIG_HOME:-\$HOME/.config}/soldat/$(basename "$p")"

      wrapProgram "$p" \
        --run "mkdir -p \"$configDir\"" \
        --add-flags "-fs_portable 0" \
        --add-flags "-fs_userpath \"$configDir\"" \
        --add-flags "-fs_basepath \"${base}/share/soldat\""
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soldat is a unique 2D (side-view) multiplayer action game";
    license = [ licenses.mit base.meta.license ];
    inherit (src.meta) homepage;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.x86_64 ++ platforms.i686;
    # portability currently mainly limited by fpc
    # in nixpkgs which doesn't work on darwin,
    # aarch64 and arm support should be possible:
    # https://github.com/Soldat/soldat/issues/45
  };
}
