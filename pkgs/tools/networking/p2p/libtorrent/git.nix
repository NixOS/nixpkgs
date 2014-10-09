{ stdenv, autoconf, automake, cppunit, fetchFromGitHub, pkgconfig, openssl, libsigcxx, libtool, zlib }:

stdenv.mkDerivation {
  name = "libtorrent-git";

  src = fetchFromGitHub rec {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "c60d2b9475804e41649356fa0301e9f770798f8d";
    sha256 = "1x78g5yd4q0ksdsw91awz2a1ax8zyfy5b53gbbil4fpjy96vb577";
  };
  
  buildInputs = [ autoconf automake cppunit pkgconfig openssl libsigcxx libtool zlib ];

  configureFlags = "--disable-dependency-tracking --enable-aligned";

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "A BitTorrent library written in C++ for *nix, with a focus on high performance and good code";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}