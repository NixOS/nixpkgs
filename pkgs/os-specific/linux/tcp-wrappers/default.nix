{ fetchurl, stdenv }:

let
  vanillaVersion = "7.6.q";
  patchLevel = "26";
in stdenv.mkDerivation rec {
  name = "tcp-wrappers-${version}";
  version = "${vanillaVersion}-${patchLevel}";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_${vanillaVersion}.orig.tar.gz";
    sha256 = "0p9ilj4v96q32klavx0phw9va21fjp8vpk11nbh6v2ppxnnxfhwm";
  };

  debian = fetchurl {
    url = "mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_${version}.debian.tar.xz";
    sha256 = "1dcdhi9lwzv7g19ggwxms2msq9fy14rl09rjqb10hwv0jix7z8j8";
  };

  prePatch = ''
    tar -xaf $debian
    patches="$(cat debian/patches/series | sed 's,^,debian/patches/,') $patches"
  '';

  makeFlags = [ "STRINGS=" "REAL_DAEMON_DIR=$(out)/bin" "linux" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp -v safe_finger tcpd tcpdchk tcpdmatch try-from "$out/bin"

    mkdir -p "$out/lib"
    cp -v shared/lib*.so* "$out/lib"

    mkdir -p "$out/include"
    cp -v *.h "$out/include"

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
    platforms = stdenv.lib.platforms.linux;
  };
}
