{ stdenv
, fetchurl
, ncurses
, readline
}:

stdenv.mkDerivation rec {
  pname = "ytree";
  version = "2.02";

  src = fetchurl {
    url = "https://han.de/~werner/${pname}-${version}.tar.gz";
    sha256 = "1v70l244rc22f20gac1zha1smrhqkag45jn0iwgcyngfdfml3gz5";
  };

  buildInputs = [
    ncurses readline
  ];

  # don't save timestamp, in order to improve reproducibility
  postPatch = ''
    substituteInPlace Makefile --replace 'gzip' 'gzip -n'
  '';

  preBuild = ''
    makeFlagsArray+=(CC="cc"
                     ADD_CFLAGS=""
                     COLOR="-DCOLOR_SUPPORT"
                     CLOCK="-DCLOCK_SUPPORT"
                     READLINE="-DREADLINE_SUPPORT"
                     CFLAGS="-D_GNU_SOURCE -DWITH_UTF8 $(ADD_CFLAGS) $(COLOR) $(CLOCK) $(READLINE)"
                     LDFLAGS="-lncursesw -lreadline")
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "A curses-based file manager similar to DOS Xtree(TM)";
    homepage = "https://www.han.de/~werner/ytree.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
# TODO: X11 support
