{ stdenv
, fetchurl
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXfont2";
  version = "2.0.6";
  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXfont2-2.0.6.tar.xz";
    hash = "sha256-dMogAX6w+z9W2NXmBoX1YPyF5f89hMYcTLiR5AwnrvQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
