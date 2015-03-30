{ stdenv, fetchFromGitHub, bison, flex, libcli, libnet
, libnetfilter_conntrack, libnl, libpcap, libsodium, liburcu, ncurses, perl
, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  version = "v0.5.9-rc4-53-gdd5d906";
  name = "netsniff-ng-${version}";

  src = fetchFromGitHub rec { # Upstream recommends and supports git
    repo = "netsniff-ng";
    owner = repo;
    rev = "dd5d906c40db5264d8d33c37565b39540f0258c8";
    sha256 = "0iwnfjbxiv10zk5mfpnvs2xb88f14hv1a156kn9mhasszknp0a57";
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
