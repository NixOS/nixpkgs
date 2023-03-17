{lib, stdenv, fetchurl, ghostscript}:

stdenv.mkDerivation rec {
  pname = "lout";
  version = "3.40";

  src = fetchurl {
    urls = [
      "ftp://ftp.cs.usyd.edu.au/jeff/lout/${pname}-${version}.tar.gz"
      "mirror://savannah/lout/${pname}-${version}.tar.gz"      # new!
      "mirror://sourceforge/lout/${pname}-${version}.tar.gz"   # to be phased out
      # XXX: We could add the CTAN mirrors
      # (see https://www.ctan.org/tex-archive/support/lout/).
    ];
    sha256 = "1gb8vb1wl7ikn269dd1c7ihqhkyrwk19jwx5kd0rdvbk6g7g25ix";
  };

  patches = [
    # https://build.opensuse.org/request/show/843612
    ./CVE-2019-19917-and-CVE-2019-19918.patch
  ];

  buildInputs = [ ghostscript ];
  builder = ./builder.sh;

  meta = {
    description = "Document layout system similar in style to LaTeX";

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

    # Author's page: http://jeffreykingston.id.au/lout/
    # Wiki: https://sourceforge.net/p/lout/wiki/
    homepage = "https://savannah.nongnu.org/projects/lout/";

    license = lib.licenses.gpl3Plus;

    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
