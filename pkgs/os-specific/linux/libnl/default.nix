{ stdenv, lib, fetchFromGitHub, autoreconfHook, bison, flex, pkgconfig }:

let version = "3.3.0"; in
stdenv.mkDerivation {
  name = "libnl-${version}";

  src = fetchFromGitHub {
    repo = "libnl";
    owner = "thom311";
    rev = "libnl${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1796kyq2lkhz2802v9kp32vlxf8ynlyqgyw9nhmry3qh5d0ahcsv";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig ];

  meta = with lib; {
    inherit version;
    homepage = http://www.infradead.org/~tgr/libnl/;
    description = "Linux Netlink interface library suite";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
