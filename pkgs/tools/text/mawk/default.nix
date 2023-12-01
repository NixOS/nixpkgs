{ lib, stdenv, fetchurl, buildPackages }:

stdenv.mkDerivation rec {
  pname = "mawk";
  version = "1.3.4-20230525";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/mawk-${version}.tgz"
      "https://invisible-mirror.net/archives/mawk/mawk-${version}.tgz"
    ];
    sha256 = "sha256-VjnRS7kSQ3Oz1/lX0rklrYrZZW1GISw/I9vKgQzJJp8=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  meta = with lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = "https://invisible-island.net/mawk/mawk.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}
