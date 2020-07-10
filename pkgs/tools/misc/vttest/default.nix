{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20200420";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "03li63v9mbsqn4cw6d769r1a6iaixi80m2c32y32vc9i5k3ik43c";
  };

  meta = with stdenv.lib; {
    description = "Tests the compatibility so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

