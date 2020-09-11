{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20200610";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "0181lk999gfqk8pkd4yx0qrz9r3k9a0z0i50wcayp7z1n1ivqllb";
  };

  meta = with stdenv.lib; {
    description = "Tests the compatibility so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

