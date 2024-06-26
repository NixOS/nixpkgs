{
  stdenv,
  lib,
  fetchgit,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "sfeed";
  version = "2.0";

  src = fetchgit {
    url = "git://git.codemadness.org/sfeed";
    rev = version;
    sha256 = "sha256-DbzJWi9wAc7w2Z0bQt5PEFOuu9L3xzNrJvCocvCer34=";
  };

  buildInputs = [ ncurses ];

  makeFlags =
    [
      "RANLIB:=$(RANLIB)"
      "SFEED_CURSES_LDFLAGS:=-lncurses"
    ]
    # use macOS's strlcat() and strlcpy() instead of vendored ones
    ++ lib.optional stdenv.isDarwin "COMPATOBJ:=";

  installFlags = [ "PREFIX=$(out)" ];

  # otherwise does not find SIGWINCH
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-D_DARWIN_C_SOURCE";

  meta = with lib; {
    homepage = "https://codemadness.org/sfeed-simple-feed-parser.html";
    description = "RSS and Atom parser (and some format programs)";
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
