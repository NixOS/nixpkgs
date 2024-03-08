{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "b43-fwcutter";
  version = "019";

  src = fetchurl {
    url = "https://bues.ch/b43/fwcutter/b43-fwcutter-${version}.tar.bz2";
    sha256 = "1ki1f5fy3yrw843r697f8mqqdz0pbsbqnvg4yzkhibpn1lqqbsnn";
  };

  patches = [ ./no-root-install.patch ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "Firmware extractor for cards supported by the b43 kernel module";
    homepage = "http://wireless.kernel.org/en/users/Drivers/b43";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
  };
}
