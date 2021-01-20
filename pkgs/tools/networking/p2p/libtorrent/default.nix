# NOTE: this is rakshava's version of libtorrent, used mainly by rtorrent
# This is NOT libtorrent-rasterbar, used by Deluge, qbitttorent, and others
{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, cppunit, openssl, libsigcxx, zlib
}:

stdenv.mkDerivation rec {
  pname = "libtorrent";
  version = "0.13.8";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h5y6ab3gs20yyprdfwcw8fh1c6czs4yrdj0kf54d2vp9qwz685r";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ cppunit openssl libsigcxx zlib ];

  meta = with lib; {
    homepage = "https://github.com/rakshasa/libtorrent";
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

    platforms = platforms.unix;
    maintainers = with maintainers; [ ebzzry codyopel ];
  };
}
