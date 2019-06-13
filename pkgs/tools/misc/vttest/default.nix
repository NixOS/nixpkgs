{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20190105";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "0wagaywzc6pq59m8gpcblag7gyjjarc0qx050arr1sy8hd3yy0sp";
  };

  meta = with stdenv.lib; {
    description = "Tests the compatibility so-called 'VT100-compatible' terminals";
    homepage = https://invisible-island.net/vttest/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}

