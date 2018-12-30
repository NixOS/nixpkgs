{ lib, fetchFromGitHub, python3Packages, lilypond }:

python3Packages.buildPythonApplication rec {
  name = "frescobaldi-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "wbsoft";
    repo = "frescobaldi";
    rev = "v${version}";
    sha256 = "1yn18pwsjxpxz5j3yfysmaif8k0vqahj5c7ays9cxsylpg9hl7jd";
  };

  propagatedBuildInputs = with python3Packages; [
    lilypond pygame python-ly sip
    pyqt5_with_qtwebkit (poppler-qt5.override { pyqt5 = pyqt5_with_qtwebkit; })
  ];

  # no tests in shipped with upstream
  doCheck = false;

  meta = with lib; {
    homepage = http://frescobaldi.org/;
    description = ''Frescobaldi is a LilyPond sheet music text editor'';
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
    maintainers = with maintainers; [ sepi ma27 ];
    platforms = platforms.all;
  };
}
