{ stdenv, fetchurl, ncurses, perl, xz, libiconv, gawk, procps, interactive ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "texinfo-6.3";

  src = fetchurl {
    url = "mirror://gnu/texinfo/${name}.tar.xz";
    sha256 = "0fpr9kdjjl6nj2pc50k2zr7134hvqz8bi8pfqa7131a9lpzz6v14";
  };

  buildInputs = [ perl xz ]
    ++ optionals stdenv.isSunOS [ libiconv gawk ]
    ++ optional interactive ncurses
    ++ optional doCheck procps; # for tests

  configureFlags = stdenv.lib.optional stdenv.isSunOS "AWK=${gawk}/bin/awk";

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  preInstall = ''
    installFlags="TEXMF=$out/texmf-dist";
    installTargets="install install-tex";
  '';

  doCheck = interactive # simplify bootstrapping
    && !stdenv.isDarwin && !stdenv.isSunOS/*flaky*/;

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/texinfo/;
    description = "The GNU documentation system";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vrthra ];

    longDescription = ''
      Texinfo is the official documentation format of the GNU project.
      It was invented by Richard Stallman and Bob Chassell many years
      ago, loosely based on Brian Reid's Scribe and other formatting
      languages of the time.  It is used by many non-GNU projects as
      well.

      Texinfo uses a single source file to produce output in a number
      of formats, both online and printed (dvi, html, info, pdf, xml,
      etc.).  This means that instead of writing different documents
      for online information and another for a printed manual, you
      need write only one document.  And when the work is revised, you
      need revise only that one document.  The Texinfo system is
      well-integrated with GNU Emacs.
    '';
  };
}
