{ stdenv, fetchFromGitHub, pkgconfig
, libtool, autoconf, automake, cppunit
, openssl, libsigcxx, zlib, boost, boost-build }:

stdenv.mkDerivation rec {
  name = "libtorrent-${version}";
  version = "1.1.14";

  src = fetchFromGitHub rec {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "libtorrent-1_1_4";
    sha256 = "0h6gfj0swhjzxmpqgdma4i9kr99gsfhb6j3icpfbg09hcza3zhiv";
  };

  buildInputs = [ pkgconfig libtool autoconf automake cppunit openssl libsigcxx zlib boost boost-build ];

  # preConfigure = "./autotool.sh";

  buildPhase = "bjam release";

  installPhase = "bjam --prefix=$out release install";

  meta = with stdenv.lib; {
    homepage = http://www.libtorrent.org/;
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

    platforms = platforms.linux;
    maintainers = with maintainers; [ ebzzry codyopel ];
  };
}
