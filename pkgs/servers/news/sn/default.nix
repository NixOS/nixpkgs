{ lib
, stdenv
, fetchurl
, ucspi-tcp
, zlib
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sn";
  version = "0.3.8";

  src = fetchurl {
    url = "https://www.ibiblio.org/pub/Linux/system/news/transport/sn-${finalAttrs.version}.tar.bz2";
    hash = "sha256-jOfHfVh4FJk8on1bvyu4sq0TERmVthE9yRdIRZbb3fA=";
  };
  postPatch = ''
    substituteInPlace Makefile \
      --replace  '/usr/local' '${placeholder "out"}'
  '';
  buildInputs = [
    ucspi-tcp
    zlib
  ];

  preInstall = ''
    mkdir -p $out/sbin $out/man/man8
  '';
  meta = {
    homepage = "https://patrik.iki.fi/sn/";
    description = "A small news system for small sites";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ne9z ];
    platforms = lib.platforms.unix;
  };
})
