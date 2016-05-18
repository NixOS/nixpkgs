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

  prePatch = ''
    cd upstream/tarballs
    tar xzvf *
    cd tcp_wrappers_7.6
  '';

  postPatch = ''
    for patch in debian/patches/*; do
      echo "applying Debian patch \`$(basename $patch)'..."
      patch --batch -p1 < $patch
    done
  '';

  buildPhase = ''
    make REAL_DAEMON_DIR="$out/sbin" linux
  '';

  installPhase = ''
    mkdir -p "$out/sbin"
    cp -v safe_finger tcpd tcpdchk tcpdmatch try-from "$out/sbin"

    mkdir -p "$out/lib"
    cp -v shared/lib*.so* "$out/lib"

    mkdir -p "$out/include"
    cp -v *.h "$out/include"

    mkdir -p "$out/man"
    for i in 3 5 8;
    do
      mkdir -p "$out/man/man$i"
      cp *.$i "$out/man/man$i" ;
    done
  '';

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
    platforms = stdenv.lib.platforms.unix;
  };
}
