{ stdenv, fetchFromGitHub, bison, flex, libcli, libnet
, libnetfilter_conntrack, libnl, libpcap, libsodium, liburcu, ncurses, perl
, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  version = "0.5.9-rc4-49-g6f54288";
  name = "netsniff-ng-${version}";

  src = fetchFromGitHub rec { # Upstream recommends and supports git
    repo = "netsniff-ng";
    owner = repo;
    rev = "6f542884d002d55d517a50dd9892068e95400b25";
    sha256 = "0j7rqigfn9zazmzi8w3hapzi8028jr3q27lwyjw7k7lpnayj5iaa";
  };

  buildInputs = [ bison flex libcli libnet libnl libnetfilter_conntrack
    libpcap libsodium liburcu ncurses perl pkgconfig zlib ];

  # ./configure is not autoGNU but some home-brewn magic
  configurePhase = ''
    patchShebangs configure
    substituteInPlace configure --replace "which" "command -v"
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
