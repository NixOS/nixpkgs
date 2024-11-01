{ lib, stdenv, fetchurl, bison }:

stdenv.mkDerivation rec {
  pname = "openbgpd";
  version = "7.2";

  src = fetchurl {
    url =
      "https://cdn.openbsd.org/pub/OpenBSD/OpenBGPD/${pname}-${version}.tar.gz";
    sha256 = "sha256-5PQGEgZ6DJ7kQMwUOOmEW+j1KaaHLjaQ9QjsQChqBYw=";
  };

  patches = [ ./openbgpd-paths.patch ];

  configureFlags = [ "--with-runstatedir=/run" "--sysconfdir=/etc" ];

  nativeBuildInputs = [ bison ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: bgpd-rde_peer.o:/build/source/src/bgpd/bgpd.h:133: multiple definition of `bgpd_process';
  #     bgpd-bgpd.o:/build/source/src/bgpd/bgpd.h:133: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = with lib; {
    description =
      "A free implementation of the Border Gateway Protocol, Version 4. It allows ordinary machines to be used as routers exchanging routes with other systems speaking the BGP protocol";
    license = licenses.isc;
    homepage = "http://www.openbgpd.org/";
    maintainers = with maintainers; [ kloenk ];
    platforms = platforms.linux;
  };
}
