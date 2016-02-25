{ stdenv, fetchurl, pythonPackages, lilypond, pyqt4, pygame }:

pythonPackages.buildPythonApplication rec {
  name = "frescobaldi-${version}";
  version = "2.0.16";

  src = fetchurl {
    url = "https://github.com/wbsoft/frescobaldi/releases/download/"
          + "v2.0.16/${name}.tar.gz";
    sha256 = "12pabvq5b2lq84q3kx8lh02zh6ali6v4wnin2k2ycnm45mk9ms6q";
  };

  propagatedBuildInputs = with pythonPackages; [ lilypond
    pyqt4 poppler-qt4 pygame ];

  patches = [ ./setup.cfg.patch ./python-path.patch ];

  meta = with stdenv.lib; {
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
    maintainers = [ maintainers.sepi ];
    platforms = platforms.all;
  };
}
