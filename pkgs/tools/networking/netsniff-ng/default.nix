{ stdenv, fetchFromGitHub, bison, flex, geoip, libcli, libnet
, libnetfilter_conntrack, libnl, libpcap, libsodium, liburcu, ncurses, perl
, pkgconfig, which, zlib }:

stdenv.mkDerivation rec {
  version = "0.5.9-rc4-40-g5107740";
  name = "netsniff-ng-${version}";

  src = fetchFromGitHub rec { # Upstream recommends and supports git
    repo = "netsniff-ng";
    owner = repo;
    rev = "5107740603d10feed6104afd75042970cb392843";
    sha256 = "1z3b7pa5rhz37dhfb1riy1j9lg917bs4z7clqbxm1hzi1x2ln988";
  };

  buildInputs = [ bison flex geoip libcli libnet libnl libnetfilter_conntrack
    libpcap libsodium liburcu ncurses perl pkgconfig which zlib ];

  # ./configure is not autoGNU but some home-brewn magic
  configurePhase = ''
    patchShebangs configure
    NACL_INC_DIR=${libsodium}/include/sodium NACL_LIB=sodium ./configure
  '';

  enableParallelBuilding = true;

  # Tries to install to /etc, but they're more like /share files anyway
  makeFlags = "PREFIX=$(out) ETCDIR=$(out)/etc";

  meta = with stdenv.lib; {
    description = "Swiss army knife for daily Linux network plumbing";
    longDescription = ''
      netsniff-ng is a free Linux networking toolkit. Its gain of performance
      is reached by zero-copy mechanisms, so that on packet reception and
      transmission the kernel does not need to copy packets from kernel space
      to user space and vice versa. The toolkit can be used for network
      development and analysis, debugging, auditing or network reconnaissance.
    '';
    homepage = http://netsniff-ng.org/;
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
