{ stdenv
, fetchurl
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-openchrome";
  version = "0.6.0";
  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://xorg/individual/driver/xf86-video-openchrome-0.6.0.tar.bz2";
    hash = "sha256-2il1xjeTWN5SwSV3EMZ+tZE5p/ChzSjQDMZMw+HAL3U=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
