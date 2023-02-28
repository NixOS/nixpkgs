{ lib, stdenv, fetchurl, libnfnetlink }:

stdenv.mkDerivation rec {
  pname = "minissdpd";
  version = "1.6.0";

  src = fetchurl {
    sha256 = "sha256-9MLepqRy4KXMncotxMH8NrpVOOrPjXk4JSkyUXJVRr0=";
    url = "http://miniupnp.free.fr/files/download.php?file=${pname}-${version}.tar.gz";
    name = "${pname}-${version}.tar.gz";
  };

  buildInputs = [ libnfnetlink ];

  installFlags = [ "PREFIX=$(out)" "INSTALLPREFIX=$(out)" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Small daemon to speed up UPnP device discoveries";
    longDescription = ''
      MiniSSDPd receives NOTIFY packets and stores (caches) that information
      for later use by UPnP Control Points on the machine. MiniSSDPd receives
      M-SEARCH packets and answers on behalf of the UPnP devices running on
      the machine. Software must be patched in order to take advantage of
      MiniSSDPd, and MiniSSDPd must be started before any other UPnP program.
    '';
    homepage = "http://miniupnp.free.fr/minissdpd.html";
    downloadPage = "http://miniupnp.free.fr/files/";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
