{ fetchurl, lib, stdenv, python3Packages, texinfo }:

python3Packages.buildPythonApplication rec {
  pname = "rubber";
  version = "1.5.1";

  src = fetchurl {
    url = "https://launchpad.net/rubber/trunk/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "178dmrp0mza5gqjiqgk6dqs0c10s0c517pk6k9pjbam86vf47a1p";
  };

  # I'm sure there is a better way to pass these parameters to the build script...
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pdf  = True' 'pdf = False' \
      --replace '$base/man'   'share/man' \
      --replace '$base/info'  'share/info' \
      --replace '$base/share' 'share'
  '';

  nativeBuildInputs = [ texinfo ];

  checkPhase = ''
    cd tests && ${stdenv.shell} run.sh
  '';

  meta = with lib; {
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
    license = licenses.gpl2Plus;
    homepage = "https://launchpad.net/rubber";
    maintainers = with maintainers; [ ttuegel peterhoeg ];
    platforms = platforms.unix;
  };
}
