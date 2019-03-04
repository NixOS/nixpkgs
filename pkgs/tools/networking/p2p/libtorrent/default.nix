# NOTE: this is rakshava's version of libtorrent, used mainly by rtorrent
# This is NOT libtorrent-rasterbar, used by Deluge, qbitttorent, and others
{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig
, libtool, autoconf, automake, cppunit
, openssl, libsigcxx, zlib }:

stdenv.mkDerivation rec {
  pname = "libtorrent";
  version = "0.13.8";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h5y6ab3gs20yyprdfwcw8fh1c6czs4yrdj0kf54d2vp9qwz685r";
  };

  patches = [
    (fetchpatch {
      name = "openssl_1_1.patch";
      url = https://github.com/rakshasa/libtorrent/commit/7b29b6bd2547e72e22b9b7981df27092842d2a10.patch;
      sha256 = "0nrh2f9bvi1p0gnsck2gzkgd5dd91yk26gcrhrj2f7wh1d4m0pdd";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libtool autoconf automake cppunit openssl libsigcxx zlib ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = "https://github.com/rakshasa/libtorrent";
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

    platforms = platforms.unix;
    maintainers = with maintainers; [ ebzzry codyopel ];
  };
}
