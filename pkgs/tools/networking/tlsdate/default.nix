{ stdenv, fetchFromGitHub, fetchpatch
, autoconf
, automake
, libevent
, libtool
, pkgconfig
, openssl
}:

stdenv.mkDerivation rec {
  version = "0.0.13";
  name = "tlsdate-${version}";

  src = fetchFromGitHub {
    owner = "ioerror";
    repo = "tlsdate";
    rev = name;
    sha256 = "0w3v63qmbhpqlxjsvf4k3zp90k6mdzi8cdpgshan9iphy1f44xgl";
  };

  patches = [
    (fetchpatch {
      name = "tlsdate-no_sslv3.patch";
      url = "https://github.com/ioerror/tlsdate/commit/f9d3cba7536d1679e98172ccbddad32bc9ae490c.patch";
      sha256 = "0prv46vxvb4paxaswmc6ix0kd5sp0552i5msdldnhg9fysbac8s0";
    })
  ];

  buildInputs = [
    autoconf
    automake
    libevent
    libtool
    pkgconfig
    openssl
  ];

  preConfigure = ''
    export COMPILE_DATE=0
    ./autogen.sh
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Secure parasitic rdate replacement";
    homepage = https://github.com/ioerror/tlsdate;
    maintainers = with maintainers; [ tv fpletz ];
    platforms = platforms.allBut [ "darwin" ];
  };
}
