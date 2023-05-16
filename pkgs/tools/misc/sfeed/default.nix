{ stdenv, lib, fetchgit, ncurses }:

stdenv.mkDerivation rec {
  pname = "sfeed";
<<<<<<< HEAD
  version = "1.9";
=======
  version = "1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchgit {
    url = "git://git.codemadness.org/sfeed";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-VZChiJ1m2d0iEM5ATXMqCJVpHZcBIkqIorFvQlY0/mw=";
=======
    sha256 = "sha256-oosBwLCVZDy29RNxLXie0IPRUxAmT6qJlQGHypWScuk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ncurses ];

  makeFlags = [ "RANLIB:=$(RANLIB)" "SFEED_CURSES_LDFLAGS:=-lncurses" ]
    # use macOS's strlcat() and strlcpy() instead of vendored ones
    ++ lib.optional stdenv.isDarwin "COMPATOBJ:=";

  installFlags = [ "PREFIX=$(out)" ];

  # otherwise does not find SIGWINCH
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-D_DARWIN_C_SOURCE";

  meta = with lib; {
    homepage = "https://codemadness.org/sfeed-simple-feed-parser.html";
    description = "A RSS and Atom parser (and some format programs)";
    longDescription = ''
      It converts RSS or Atom feeds from XML to a TAB-separated file. There are
      formatting programs included to convert this TAB-separated format to
      various other formats. There are also some programs and scripts included
      to import and export OPML and to fetch, filter, merge and order feed
      items.
    '';
    license = licenses.isc;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.all;
  };
}
