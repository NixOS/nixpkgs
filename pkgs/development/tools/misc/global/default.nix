{ fetchurl, stdenv, libtool, ncurses }:

stdenv.mkDerivation rec {
  name = "global-6.2.12";

  src = fetchurl {
    url = "mirror://gnu/global/${name}.tar.gz";
    sha256 = "05jkhya1cs6yqhkf8nw5x56adkxxrqyga7sq7hx44dbf7alczwfa";
  };

  buildInputs = [ libtool ncurses ];

  configurePhase =
    '' ./configure --prefix="$out" --disable-static ''
    + ''--with-posix-sort=$(type -p sort) ''
    + ''--with-ltdl-include=${libtool}/include --with-ltdl-lib=${libtool}/lib ''
    + ''--with-ncurses=${ncurses}'';

  doCheck = true;

  postInstall = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp -v *.el "$out/share/emacs/site-lisp"
  '';

  meta = {
    description = "Source code tag system";

    longDescription = ''
      GNU GLOBAL is a source code tagging system that works the same way
      across diverse environments (Emacs, vi, less, Bash, web browser, etc).
      You can locate specified objects in source files and move there easily.
      It is useful for hacking a large project containing many
      subdirectories, many #ifdef and many main() functions.  It is similar
      to ctags or etags but is different from them at the point of
      independence of any editor.  It runs on a UNIX (POSIX) compatible
      operating system like GNU and BSD.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/global/;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
