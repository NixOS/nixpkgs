{ stdenv, fetchFromGitHub, ncurses, uthash, pkg-config }:

stdenv.mkDerivation {
  name = "logtop-0.7";

  src = fetchFromGitHub {
    rev = "a0935ab2e7056feb3e8a90f5129990c9b335a587";
    owner = "JulienPalard";
    repo  ="logtop";
    sha256 = "1f8vk9gybldxvc0kwz38jxmwvzwangsvlfslpsx8zf04nvbkqi12";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses uthash ];

  installFlags = [ "DESTDIR=$(out)" ];

  postConfigure = ''
    substituteInPlace Makefile --replace /usr ""
  '';

  meta = with stdenv.lib; {
    description = "Displays a real-time count of strings received from stdin";
    longDescription = ''
      logtop displays a real-time count of strings received from stdin.
      It can be useful in some cases, like getting the IP flooding your
      server or the top buzzing article of your blog
    '';
    license = licenses.bsd2;
    homepage = "https://github.com/JulienPalard/logtop";
    platforms = platforms.unix;
    maintainers = [ maintainers.starcraft66 ];
  };
}
