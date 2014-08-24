{ fetchurl, stdenv, python, texinfo }:

stdenv.mkDerivation rec {
  name = "rubber-1.1";

  src = fetchurl {
    url = "http://ebeffara.free.fr/pub/${name}.tar.gz";
    sha256 = "1xbkv8ll889933gyi2a5hj7hhh216k04gn8fwz5lfv5iz8s34gbq";
  };

  buildInputs = [ python texinfo ];

  patchPhase = "substituteInPlace configure --replace which \"type -P\"";

  meta = {
    description = "Rubber, a wrapper for LaTeX and friends";

    longDescription = ''
      Rubber is a program whose purpose is to handle all tasks related
      to the compilation of LaTeX documents.  This includes compiling
      the document itself, of course, enough times so that all
      references are defined, and running BibTeX to manage
      bibliographic references.  Automatic execution of dvips to
      produce PostScript documents is also included, as well as usage
      of pdfLaTeX to produce PDF documents.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = http://www.pps.jussieu.fr/~beffara/soft/rubber/;
  };
}
