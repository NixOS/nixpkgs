{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20190710";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "00v3a94vpmbdziizdw2dj4bfwzfzfs2lc0ijxv98ln1w01w412q4";
  };

  meta = with stdenv.lib; {
    description = "Tests the compatibility so-called 'VT100-compatible' terminals";
    homepage = https://invisible-island.net/vttest/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}

