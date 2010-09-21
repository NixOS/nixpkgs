{stdenv, fetchurl, ghostscript}:

stdenv.mkDerivation rec {
  name = "lout-3.39";

  src = fetchurl {
    urls = [
      "ftp://ftp.cs.usyd.edu.au/jeff/lout/${name}.tar.gz"
      "mirror://savannah/lout/${name}.tar.gz"      # new!
      "mirror://sourceforge/lout/${name}.tar.gz"   # to be phased out
      # XXX: We could add the CTAN mirrors
      # (see http://www.ctan.org/tex-archive/support/lout/).
    ];
    sha256 = "12gkyqrn0kaa8xq7sc7v3wm407pz2fxg9ngc75aybhi5z825b9vq";
  };

  buildInputs = [ ghostscript ];
  builder = ./builder.sh;

  meta = {
    description = "Lout, a document layout system similar in style to LaTeX";

    longDescription = ''
      The Lout document formatting system is now reads a high-level
      description of a document similar in style to LaTeX and produces
      a PostScript or plain text output file.

      Lout offers an unprecedented range of advanced features,
      including optimal paragraph and page breaking, automatic
      hyphenation, PostScript EPS file inclusion and generation,
      equation formatting, tables, diagrams, rotation and scaling,
      sorted indexes, bibliographic databases, running headers and
      odd-even pages, automatic cross referencing, multilingual
      documents including hyphenation (most European languages are
      supported), formatting of computer programs, and much more, all
      ready to use.  Furthermore, Lout is easily extended with
      definitions which are very much easier to write than troff of
      TeX macros because Lout is a high-level, purely functional
      language, the outcome of an eight-year research project that
      went back to the beginning.
    '';

    # Author's page: http://www.cs.usyd.edu.au/~jeff/ .
    homepage = http://lout.wiki.sourceforge.net/;

    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
