{ stdenv, lib, fetchurl, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer
, SDL2_net , SDL2_gfx, zlib, physfs, curl, libxml2, libpng, pkg-config
, libGL, autoreconfHook }:
stdenv.mkDerivation rec {
  pname = "manaplus";
  version = "2.1.3.17";

  src = fetchurl {
    url = "https://download.evolonline.org/manaplus/download/${version}/manaplus-${version}.tar.xz";
    sha256 = "sha256-6NFqxUjEAp7aiIScyTOFh2tT7PfuTCKH1vTgPpTm+j0=";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config
  ];

  buildInputs = [
    SDL2 SDL2_image SDL2_ttf SDL2_mixer SDL2_net SDL2_gfx zlib
    physfs curl libxml2 libpng libGL
  ];

  configureFlags = [ "--with-sdl2" "--without-dyecmd" ];

  enableParallelBuilding = true;

  meta = {
    maintainers = [ ];
    description = "Free OpenSource 2D MMORPG client";
    homepage = "https://manaplus.org/";
    license = lib.licenses.gpl2Plus;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
