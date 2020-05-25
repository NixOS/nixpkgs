{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20200303";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "1g27yp37kh57hmwicw3ndnsapsbqzk2cnjccmvyj4zw2z0l5iaj9";
  };

  meta = with stdenv.lib; {
    description = "Tests the compatibility so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

