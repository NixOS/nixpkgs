{ fetchurl, stdenv, libtool, ncurses, ctags, sqlite
, pythonPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "global-6.4";

  src = fetchurl {
    url = "mirror://gnu/global/${name}.tar.gz";
    sha256 = "13i4zwx6gaibc4j79wd0hgxysw8ibxz9c018zxhydnxlyadzcnri";
  };

  buildInputs = [ libtool ncurses makeWrapper ];
  propagatedBuildInputs = [ pythonPackages.pygments ];

  configurePhase =
    '' ./configure --prefix="$out" --disable-static ''
    + ''--with-posix-sort=$(type -p sort) ''
    + ''--with-ltdl-include=${libtool}/include --with-ltdl-lib=${libtool}/lib ''
    + ''--with-ncurses=${ncurses} ''
    + ''--with-sqlite3=${sqlite} ''
    + ''--with-exuberant-ctags=${ctags}/bin/ctags'';

  doCheck = true;

  postInstall = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp -v *.el "$out/share/emacs/site-lisp"

    wrapProgram $out/bin/gtags \
      --prefix PYTHONPATH : "$(toPythonPath ${pythonPackages.pygments})"
    wrapProgram $out/bin/global \
      --prefix PYTHONPATH : "$(toPythonPath ${pythonPackages.pygments})"
  '';

  meta = with stdenv.lib; {
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

    license = licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/global/;

    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
