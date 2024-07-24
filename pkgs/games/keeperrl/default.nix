{ lib
, stdenv
, fetchFromGitHub
, requireFile
, openal
, curl
, libogg
, libvorbis
, SDL2
, SDL2_image
, zlib
, clang
, libtheora
, unfree_assets ? false }:

let
  pname = "keeperrl";
  version = "alpha34";

  free_src = fetchFromGitHub {
    owner = "miki151";
    repo = pname;
    rev = version;
    sha256 = "sha256-0sww+ppctXvxMouclG3OdXpcNgrrOZJw9z8s2GhJ+IE=";
  };

  assets = requireFile rec {
    name = "keeperrl_data_${version}.tar.gz";
    message = ''
      This nix expression requires that the KeeperRL art assets are already
      part of the store. These can be obtained from a purchased copy of the game
      and found in the "data" directory. Make a tar archive of this directory
      with

      "tar czf ${name} data"

      Then add this archive to the nix store with

      "nix-prefetch-url file://\$PWD/${name}".
    '';
    sha256 = "0115pxdzdyma2vicxgr0j21pp82gxdyrlj090s8ihp0b50f0nlll";
  };
in

stdenv.mkDerivation {
  inherit pname version;

  srcs = [ free_src ] ++ lib.optional unfree_assets assets;

  sourceRoot = free_src.name;

  postUnpack = lib.optionalString unfree_assets ''
    mv data $sourceRoot
  '';

  buildInputs = [
    openal curl libogg libvorbis libtheora SDL2 SDL2_image zlib clang
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${SDL2.dev}/include/SDL2"
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "OPT=true"
    "RELEASE=true"
    "DATA_DIR=$(out)/share"
    "ENABLE_LOCAL_USER_DIR=true"
    "NO_STEAMWORKS=true"
  ];

  installPhase = ''
    install -Dm755 keeper $out/bin/keeper
    install -Dm755 appconfig.txt $out/share/appconfig.txt

    cp -r data_free $out/share
    cp -r data_contrib $out/share
    ${lib.optionalString unfree_assets "cp -r data $out/share"}
  '';

  meta = with lib; {
    description = "Dungeon management rogue-like";
    mainProgram = "keeper";
    homepage = "https://keeperrl.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny ];
    # TODO: Add OS X
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
