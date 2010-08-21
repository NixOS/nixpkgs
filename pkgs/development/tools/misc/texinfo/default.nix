{ stdenv, fetchurl, ncurses, lzma }:

stdenv.mkDerivation rec {
  name = "texinfo-4.13a";

  src = fetchurl {
    url = "mirror://gnu/texinfo/texinfo-4.13a.tar.lzma";
    sha256 = "1rf9ckpqwixj65bw469i634897xwlgkm5i9g2hv3avl6mv7b0a3d";
  };

  buildInputs = [ ncurses ];
  buildNativeInputs = [ lzma ];

  # Disabled because we don't have zdiff in the stdenv bootstrap.
  #doCheck = true;

  meta = {
    description = "GNU Texinfo, the GNU documentation system";

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

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/texinfo/;
  };
}
