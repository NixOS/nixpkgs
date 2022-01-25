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

  meta = with lib; {
    description =
      "A free implementation of the Border Gateway Protocol, Version 4. It allows ordinary machines to be used as routers exchanging routes with other systems speaking the BGP protocol";
    license = licenses.isc;
    homepage = "http://www.openbgpd.org/";
    maintainers = with maintainers; [ kloenk ];
    platforms = platforms.linux;
  };
}
