{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libdaemon,
  bison,
  flex,
  check,
}:

stdenv.mkDerivation rec {
  pname = "radvd";
  version = "2.19";

  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${pname}-${version}.tar.xz";
    sha256 = "0h722f17h7cra1sjgrxhrrvx54mm47fs039909yhbabigxch8kjn";
  };

  nativeBuildInputs = [
    pkg-config
    bison
    flex
    check
  ];
  buildInputs = [ libdaemon ];

  # Needed for cross-compilation
  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  meta = with lib; {
    homepage = "http://www.litech.org/radvd/";
    description = "IPv6 Router Advertisement Daemon";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ fpletz ];
  };
}
