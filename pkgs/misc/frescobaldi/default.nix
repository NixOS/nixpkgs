{ lib, buildPythonApplication, fetchFromGitHub, python3Packages, pyqtwebengine, lilypond }:

buildPythonApplication rec {
  pname = "frescobaldi";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "wbsoft";
    repo = "frescobaldi";
    rev = "v${version}";
    sha256 = "1p8f4vn2dpqndw1dylmg7wms6vi69zcfj544c908s4r8rrmbycyf";
  };

  propagatedBuildInputs = with python3Packages; [
    lilypond pygame python-ly sip
    pyqt5 poppler-qt5
    pyqtwebengine
  ];

  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];

  # Needed because source is fetched from git
  preBuild = ''
    make -C i18n
    make -C linux
  '';

  # no tests in shipped with upstream
  doCheck = false;

  dontWrapQtApps = true;
  makeWrapperArgs = [
      "\${qtWrapperArgs[@]}"
  ];

  meta = with lib; {
    homepage = "https://frescobaldi.org/";
    description = "A LilyPond sheet music text editor";
    longDescription = ''
      Powerful text editor with syntax highlighting and automatic completion,
      Music view with advanced Point & Click, Midi player to proof-listen
      LilyPond-generated MIDI files, Midi capturing to enter music,
      Powerful Score Wizard to quickly setup a music score, Snippet Manager
      to store and apply text snippets, templates or scripts, Use multiple
      versions of LilyPond, automatically selects the correct version, Built-in
      LilyPond documentation browser and built-in User Guide, Smart
      layout-control functions like coloring specific objects in the PDF,
      MusicXML import, Modern user iterface with configurable colors,
      fonts and keyboard shortcuts
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sepi ];
    platforms = platforms.all;
  };
}
