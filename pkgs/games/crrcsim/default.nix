{ stdenv, fetchurl, mesa, SDL, SDL_mixer, plib, libjpeg }:
let
  version = "0.9.12";
in
stdenv.mkDerivation rec {
  name = "crrcsim-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/crrcsim/${name}.tar.gz";
    sha256 = "1yx3cn7ilwj92v6rk3zm565ap92vmky4r39na814lfglkzn6l5id";
  };

  buildInputs = [
    mesa SDL SDL_mixer plib libjpeg
  ];

  meta = {
    description = "A model-airplane flight simulator";
    maintainers = with stdenv.lib.maintainers; [ raskin the-kenny ];
    platforms = stdenv.lib.platforms.linux;
    license = "GPLv2";
  };
}

