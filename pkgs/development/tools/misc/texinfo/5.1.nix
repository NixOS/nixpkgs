{ stdenv, fetchurl, ncurses, perl }:

stdenv.mkDerivation rec {
  name = "texinfo-5.1";

  src = fetchurl {
    url = "mirror://gnu/texinfo/${name}.tar.xz";
    sha256 = "0864v5i488x3mb3v5p6nhy2kw0mqkzpa3b0453iibj81zlpq078q";
  };

  buildInputs = [ ncurses perl ];

  doCheck = true;

  meta = {
    homepage = "http://www.gnu.org/software/texinfo/";
    description = "GNU Texinfo, the GNU documentation system";
    license = stdenv.lib.licenses.gpl3Plus;

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
