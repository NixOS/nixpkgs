{ lib, stdenv, fetchurl, pkg-config, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  pname = "radvd";
  version = "2.18";

  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${pname}-${version}.tar.xz";
    sha256 = "1p2wlv3djvla0r84hdncc3wfa530xigs7z9ssc2v5r1pcpzgxgz1";
  };

  nativeBuildInputs = [ pkg-config bison flex check ];
  buildInputs = [ libdaemon ];

  meta = with lib; {
    homepage = "http://www.litech.org/radvd/";
    description = "IPv6 Router Advertisement Daemon";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ fpletz ];
  };
}
