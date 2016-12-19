{ stdenv, fetchFromGitHub, pkgconfig
, libtool, autoconf, automake, cppunit
, openssl, libsigcxx, zlib }:

stdenv.mkDerivation rec {
  name = "libtorrent-${version}";
  version = "0.13.6";

  src = fetchFromGitHub rec {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "${version}";
    sha256 = "1rvrxgb131snv9r6ksgzmd74rd9z7q46bhky0zazz7dwqqywffcp";
  };

  buildInputs = [ pkgconfig libtool autoconf automake cppunit openssl libsigcxx zlib ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = http://www.libtorrent.org/;
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

    platforms = platforms.linux;
    maintainers = with maintainers; [ ebzzry codyopel ];
  };
}
