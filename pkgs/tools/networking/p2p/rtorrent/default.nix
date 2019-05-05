{ stdenv, fetchurl, fetchFromGitHub, pkgconfig
, autoreconfHook, cppunit
, libtorrent, ncurses, libsigcxx, curl
, zlib, openssl, xmlrpc_c
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

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    cppunit libtorrent ncurses libsigcxx curl zlib openssl xmlrpc_c
  ];

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
