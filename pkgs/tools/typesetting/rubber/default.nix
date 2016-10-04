{ fetchurl, stdenv, python, pythonPackages, texinfo }:

stdenv.mkDerivation rec {
  name = "rubber-1.3";

  src = fetchurl {
    url = "https://launchpad.net/rubber/trunk/1.3/+download/rubber-1.3.tar.gz";
    sha256 = "09715apfd6a0haz1mqsxgm8sj4rwzi38gcz2kz020zxk5rh0dksh";
  };

  buildInputs = [ python texinfo ];
  nativeBuildInputs = [ pythonPackages.wrapPython ];

  patchPhase = ''
    substituteInPlace configure --replace which "type -P"
  '';

  postInstall = "wrapPythonPrograms";

  meta = {
    description = "Wrapper for LaTeX and friends";
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
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.unix;
  };
}
