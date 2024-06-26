{
  lib,
  stdenv,
  fetchFromGitLab,
  python3Packages,
  texinfo,
}:

python3Packages.buildPythonApplication rec {
  pname = "rubber";
  version = "1.6.0";

  src = fetchFromGitLab {
    owner = "latex-rubber";
    repo = "rubber";
    rev = version;
    hash = "sha256-7sv9N3PES5N41yYyXNWfaZ6IhLW6SqMiCHdamsSPQzg=";
  };

  # I'm sure there is a better way to pass these parameters to the build script...
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pdf = True' 'pdf = False' \
      --replace '$base/info'  'share/info' \
      --replace '$base/man'   'share/man' \
      --replace '$base/share' 'share'

    substituteInPlace tests/run.sh \
      --replace /var/tmp /tmp
  '';

  nativeBuildInputs = [ texinfo ];

  checkPhase = ''
    runHook preCheck

    pushd tests >/dev/null
    ${stdenv.shell} run.sh
    popd >/dev/null

    runHook postCheck
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
    homepage = "https://gitlab.com/latex-rubber/rubber";
    maintainers = with maintainers; [
      ttuegel
      peterhoeg
    ];
    platforms = platforms.unix;
    mainProgram = "rubber";
  };
}
