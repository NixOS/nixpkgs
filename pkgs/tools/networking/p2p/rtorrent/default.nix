{ stdenv, fetchurl, fetchFromGitHub, pkgconfig
, libtool, autoconf, automake, cppunit
, libtorrent, ncurses, libsigcxx, curl
, zlib, openssl, xmlrpc_c

# This no longer works
, colorSupport ? false
}:

stdenv.mkDerivation rec {
  name = "rtorrent-${version}";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "v${version}";
    sha256 = "0a9dk3cz56f7gad8ghsma79iy900rwdvzngs6k6x08nlwaqid8ga";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libtool autoconf automake cppunit
    libtorrent ncurses libsigcxx curl zlib openssl xmlrpc_c
  ];

  # Optional patch adds support for custom configurable colors
  # https://github.com/Chlorm/chlorm_overlay/blob/master/net-p2p/rtorrent/README.md
  patches = stdenv.lib.optional colorSupport (fetchurl {
    url = "https://gist.githubusercontent.com/codyopel/a816c2993f8013b5f4d6/raw/b952b32da1dcf14c61820dfcf7df00bc8918fec4/rtorrent-color.patch";
    sha256 = "00gcl7yq6261rrfzpz2k8bd7mffwya0ifji1xqcvhfw50syk8965";
  });

  preConfigure = "./autogen.sh";

  configureFlags = [ "--with-xmlrpc-c" "--with-posix-fallocate" ];

  postInstall = ''
    mkdir -p $out/share/man/man1 $out/share/doc/rtorrent
    mv doc/old/rtorrent.1 $out/share/man/man1/rtorrent.1
    mv doc/rtorrent.rc $out/share/doc/rtorrent/rtorrent.rc
  '';

  meta = with stdenv.lib; {
    homepage = https://rakshasa.github.io/rtorrent/;
    description = "An ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";

    platforms = platforms.unix;
    maintainers = with maintainers; [ ebzzry codyopel ];
    license = licenses.gpl2Plus;
  };
}
