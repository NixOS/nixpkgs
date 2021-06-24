{ lib, stdenv, fetchFromGitHub, requireFile
, openal, curl, libogg, libvorbis
, SDL2, SDL2_image, zlib
, unfree_assets ? false }:

stdenv.mkDerivation rec {
  pname = "keeperrl";
  version = "alpha28";

  free-src = fetchFromGitHub {
    owner = "miki151";
    repo = "keeperrl";
    rev = version;
    sha256 = "0isj8ijn5a89m2r5cxk4lcsq0cydx7c0h87vgr8v5cndm3rd27cy";
  };

  assets = if unfree_assets then requireFile rec {
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
    sha256 = "0115pxdzdyma2vicxgr0j21pp82gxdyrlj090s8ihp0b50f0nk53";
  } else null;

  sourceRoot = "source";

  srcs = [ free-src ] ++ lib.optional unfree_assets assets;

  postUnpack = lib.optionalString unfree_assets ''
    mv data $sourceRoot
  '';

  buildInputs = [
    openal curl libogg libvorbis SDL2 SDL2_image zlib
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${SDL2.dev}/include/SDL2"
  ];

  enableParallelBuilding = true;

  makeFlags = [ "OPT=true"
                "RELEASE=true"
                "DATA_DIR=$(out)/share"
                "ENABLE_LOCAL_USER_DIR=true"
              ];

  installPhase = ''
    install -Dm755 keeper $out/bin/keeper
    install -Dm755 appconfig.txt $out/share/appconfig.txt

    cp -r data_free $out/share
    cp -r data_contrib $out/share
    ${lib.optionalString unfree_assets "cp -r data $out/share"}
  '';

  meta = with lib; {
    description = "A dungeon management rogue-like";
    homepage = "https://keeperrl.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ chattered ];
    # TODO: Add OS X
    platforms = with platforms; [ "i686-linux" "x86_64-linux" ];
  };
}
