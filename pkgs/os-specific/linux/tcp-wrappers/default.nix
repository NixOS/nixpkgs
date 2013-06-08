{ fetchurl, stdenv }:

stdenv.mkDerivation {
  name = "tcp-wrappers-7.6";

  src = fetchurl {
    url = mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_7.6.dbs.orig.tar.gz;
    sha256 = "0k68ziinx6biwar5lcb9jvv0rp6b3vmj6861n75bvrz4w1piwkdp";
  };

  patches = [
    (fetchurl {
       url = mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_7.6.dbs-13.diff.gz;
       sha256 = "071ir20rh8ckhgrc0y99wgnlbqjgkprf0qwbv84lqw5i6qajbcnh";
     })
  ];

  builder = ./builder.sh;

  meta = {
    description = "TCP Wrappers, a network logger, also known as TCPD or LOG_TCP";

    longDescription = ''
      Wietse Venema's network logger, also known as TCPD or LOG_TCP.
      These programs log the client host name of incoming telnet, ftp,
      rsh, rlogin, finger etc. requests.  Security options are: access
      control per host, domain and/or service; detection of host name
      spoofing or host address spoofing; booby traps to implement an
      early-warning system.  The current version supports the System
      V.4 TLI network programming interface (Solaris, DG/UX) in
      addition to the traditional BSD sockets.
    '';

    homepage = ftp://ftp.porcupine.org/pub/security/index.html;

    license = "BSD-style";
  };
}
