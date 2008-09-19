{stdenv, fetchurl, ghostscript}:

stdenv.mkDerivation rec {
  name = "lout-3.37";

  src = fetchurl {
    urls = [
      "ftp://ftp.cs.usyd.edu.au/jeff/lout/${name}.tar.gz"
      "mirror://sourceforge/lout/${name}.tar.gz"
      # XXX: We could add the CTAN mirrors
      # (see http://www.ctan.org/tex-archive/support/lout/).
    ];
    sha256 = "1a388q7rpv27bvily7ii8sv2brns30g1hh77gq50qc7w0wsli0cc";
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
  };
}
