{ fetchurl, stdenv, libtool }:

stdenv.mkDerivation rec {
  name = "global-5.9.4";

  src = fetchurl {
    url = "mirror://gnu/global/${name}.tar.gz";
    sha256 = "0ay6f1fffics3vkls1xykzmz9cmgj3hdighni7asnpa38s8j0lmn";
  };

  buildInputs = [ libtool ];

  configurePhase =
    '' ./configure --prefix="$out" --disable-static --with-posix-sort=$(type -p sort) '';

  doCheck = true;

  postInstall = ''
    ensureDir "$out/share/emacs/site-lisp"
    cp -v *.el "$out/share/emacs/site-lisp"
  '';

  meta = {
    description = "GNU GLOBAL source code tag system";

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

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/global/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
