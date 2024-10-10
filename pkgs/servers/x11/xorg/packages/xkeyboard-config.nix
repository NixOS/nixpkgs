{ stdenv
, fetchurl
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkeyboard-config";
  version = "2.39";
  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-2.39.tar.xz";
    hash = "sha256-WsX1M+/3sMEWgF/iVP15ssmIJwCk+fLAcPjE6uWqpoI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
