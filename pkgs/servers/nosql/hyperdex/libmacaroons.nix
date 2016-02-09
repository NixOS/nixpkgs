{ stdenv, fetchurl, unzip, autoreconfHook, pkgconfig, libsodium, python }:

stdenv.mkDerivation rec {
  name = "libmacaroons-${version}";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/rescrv/libmacaroons/archive/releases/${version}.zip";
    sha256 = "18c44424jri0p5la6jgrnlz5p937hk7ws2mldhzjwisqyf5qld43";
  };

  buildInputs = [ unzip autoreconfHook python libsodium pkgconfig ];

  meta = with stdenv.lib; {
    description = ''Macaroons are flexible authorization credentials that
        support decentralized delegation, attenuation, and verification.'';
    homepage = https://github.com/rescrv/libmacaroons;
    license = licenses.bsd3;
  };
}
