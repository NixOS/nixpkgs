{ lib, stdenv, fetchFromGitHub, fpc, zip, makeWrapper
, SDL2, freetype, physfs, openal, gamenetworkingsockets
, xorg, autoPatchelfHook, cmake
}:

let
  base = stdenv.mkDerivation rec {
    pname = "soldat-base";
    version = "unstable-2021-09-05";

    src = fetchFromGitHub {
      name = "base";
      owner = "Soldat";
      repo = "base";
      rev = "6c74d768d511663e026e015dde788006c74406b5";
      sha256 = "175gmkdccy8rnkd95h2zqldqfydyji1hfby8b1qbnl8wz4dh08mz";
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
  version = "unstable-2021-11-01";

  src = fetchFromGitHub {
    name = "soldat";
    owner = "Soldat";
    repo = "soldat";
    rev = "7780d2948b724970af9f2aaf4fb4e4350d5438d9";
    sha256 = "0r39d1394q7kabsgq6vpdlzwsajxafsg23i0r273nggfvs3m805z";
  };

  patches = [
    # Don't build GameNetworkingSockets as an ExternalProject,
    # see https://github.com/Soldat/soldat/issues/73
    ./gamenetworkingsockets-no-external.patch
  ];

  nativeBuildInputs = [ fpc makeWrapper autoPatchelfHook cmake ];

  cmakeFlags = [
    "-DADD_ASSETS=OFF" # We provide base's smods via nix
  ];

  buildInputs = [ SDL2 freetype physfs openal gamenetworkingsockets ];
  # TODO(@sternenseemann): set proper rpath via cmake, so we don't need autoPatchelfHook
  runtimeDependencies = [ xorg.libX11 ];

  # make sure soldat{,server} find their game archive,
  # let them write their state and configuration files
  # to $XDG_CONFIG_HOME/soldat/soldat{,server} unless
  # the user specifies otherwise.
  postInstall = ''
    for p in $out/bin/soldatserver $out/bin/soldat; do
      configDir="\''${XDG_CONFIG_HOME:-\$HOME/.config}/soldat/$(basename "$p")"

      wrapProgram "$p" \
        --run "mkdir -p \"$configDir\"" \
        --add-flags "-fs_portable 0" \
        --add-flags "-fs_userpath \"$configDir\"" \
        --add-flags "-fs_basepath \"${base}/share/soldat\""
    done
  '';

  meta = with lib; {
    description = "Soldat is a unique 2D (side-view) multiplayer action game";
    license = [ licenses.mit base.meta.license ];
    inherit (src.meta) homepage;
    maintainers = [ maintainers.sternenseemann ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    # portability currently mainly limited by fpc
    # in nixpkgs which doesn't work on darwin,
    # aarch64 and arm support should be possible:
    # https://github.com/Soldat/soldat/issues/45
  };
}
