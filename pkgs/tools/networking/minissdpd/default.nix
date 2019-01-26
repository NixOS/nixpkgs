{ stdenv, fetchurl, libnfnetlink }:

stdenv.mkDerivation rec {
  name = "minissdpd-${version}";
  version = "1.5.20180223";

  src = fetchurl {
    sha256 = "1c47h1zil04jnbxiaaci2rm8jij47zp5156v48hb6m87nh4l5adv";
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    name = "${name}.tar.gz";
  };

  buildInputs = [ libnfnetlink ];

  installFlags = [ "PREFIX=$(out)" "INSTALLPREFIX=$(out)" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Small daemon to speed up UPnP device discoveries";
    longDescription = ''
      MiniSSDPd receives NOTIFY packets and stores (caches) that information
      for later use by UPnP Control Points on the machine. MiniSSDPd receives
      M-SEARCH packets and answers on behalf of the UPnP devices running on
      the machine. Software must be patched in order to take advantage of
      MiniSSDPd, and MiniSSDPd must be started before any other UPnP program.
    '';
    homepage = http://miniupnp.free.fr/minissdpd.html;
    downloadPage = http://miniupnp.free.fr/files/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
