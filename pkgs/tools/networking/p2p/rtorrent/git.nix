{ stdenv, autoconf, automake, cppunit, curl, fetchFromGitHub
, fetchurl, libsigcxx, libtool, libtorrent-git, ncurses, openssl
, pkgconfig, zlib, xmlrpc_c
, colorSupport ? false
}:

# NOTICE: changes since 0.9.4 break the current configuration syntax, an
# example configuration file using the latest changes can be found at
# https://github.com/codyopel/dotfiles/blob/master/dotfiles/rtorrent.rc

stdenv.mkDerivation {
  name = "rtorrent-git";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "7537a3c2a91d0915f1c4c89b01cd583629dc5fd4";
    sha256 = "1xnyjjff575jfq9c542yq3rr9q03z5x6xbg84d000wkjphbq7h7q";
  };

  buildInputs = [
    autoconf
    automake
    cppunit
    libtorrent-git
    ncurses
    pkgconfig
    libsigcxx
    libtool
    curl
    zlib
    openssl
    xmlrpc_c
  ];

  configureFlags = "--with-xmlrpc-c";

  # Optional patch adds support for custom configurable colors
  # https://github.com/Chlorm/chlorm_overlay/blob/master/net-p2p/rtorrent/README.md

  patches = stdenv.lib.optional colorSupport (fetchurl {
    url = "https://gist.githubusercontent.com/codyopel/a816c2993f8013b5f4d6/raw/b952b32da1dcf14c61820dfcf7df00bc8918fec4/rtorrent-color.patch";
    sha256 = "00gcl7yq6261rrfzpz2k8bd7mffwya0ifji1xqcvhfw50syk8965";
  });

  preConfigure = ''
    ./autogen.sh
  '';

  # postInstall = ''
  #   mkdir -p $out/share/man/man1 $out/share/rtorrent
  #   mv doc/rtorrent.1 $out/share/man/man1/rtorrent.1
  #   mv doc/rtorrent.rc $out/share/rtorrent/rtorrent.rc
  # '';

  meta = with stdenv.lib; {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "An ncurses client for libtorrent, ideal for use with screen or dtach";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ codyopel ];
  };
}