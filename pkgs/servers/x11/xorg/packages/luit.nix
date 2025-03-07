{ stdenv
, fetchurl
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luit";
  version = "20190106";
  builder = ../builder.sh;

  src = fetchurl {
    url = "https://invisible-mirror.net/archives/luit/luit-20190106.tgz";
    hash = "sha256-K5APZczcOPi/wRxgIAadBVumP85vkLrv6O/CIqXKOSA=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
