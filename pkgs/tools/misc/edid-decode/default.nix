{ lib, stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "edid-decode-unstable";
  version = "unstable-2018-12-06";

  src = fetchgit {
    url = "git://linuxtv.org/edid-decode.git";
    rev = "6def7bc83dfb0338632e06a8b14c93faa6af8879";
    sha256 = "0v6d6jy309pb02l377l0fpmgfsvcpiqc5bvyrli34v413mhq6p15";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp edid-decode $out/bin
  '';

  meta = {
    description = "EDID decoder and conformance tester";
    homepage = "https://cgit.freedesktop.org/xorg/app/edid-decode/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.chiiruno ];
    platforms = lib.platforms.all;
  };
}

