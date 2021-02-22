{ stdenv, lib, fetchurl, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer
, SDL2_net , SDL2_gfx, zlib, physfs, curl, libxml2, libpng, pkg-config
, libGL, autoreconfHook }:
stdenv.mkDerivation rec {
  pname = "manaplus";
  version = "1.9.3.23";

  src = fetchurl {
    url = "https://download.evolonline.org/manaplus/download/${version}/manaplus-${version}.tar.xz";
    sha256 = "1ky182p4svwdqm6cf7jbns85hidkhkhq4s17cs2p381f0klapfjz";
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
    maintainers = [ lib.maintainers.lheckemann ];
    description = "A free OpenSource 2D MMORPG client";
    homepage = "https://manaplus.org/";
    license = lib.licenses.gpl2;
  };
}
