{ stdenv, lib, fetchurl
, python, pyqt4, pythonPackages
# This little flag adds a huge number of dependencies, but we assume that
# everyone wants Anki to draw plots with statistics by default.
, plotsSupport ? true }:

let
    py = pythonPackages;
in

stdenv.mkDerivation rec {
    name = "anki-2.0.3";
    src = fetchurl {
      url = "http://ankisrs.net/download/mirror/${name}.tgz";
      sha256 = "f40ee4ef29c91101cf9978ce7bd4c513f13ca7c77497a3fb50b8128adf3a5178";
    };

    pythonPath = [ pyqt4 py.pysqlite py.sqlalchemy ]
              ++ lib.optional plotsSupport py.matplotlib;

    buildInputs = [ python py.wrapPython ];

    preConfigure = ''
      substituteInPlace anki \
        --replace /usr/share/ $out/share/

      substituteInPlace Makefile \
        --replace PREFIX=/usr PREFIX=$out \
        --replace /local/bin/ /bin/

      sed -i '/xdg-mime/ d' Makefile
    '';

    preInstall = ''
      mkdir -p $out/bin
      mkdir -p $out/share/pixmaps
      mkdir -p $out/share/applications
      mkdir -p $out/share/man/man1
    '';

    postInstall = ''
      wrapPythonPrograms
    '';

    meta = {
      homepage = http://ankisrs.net/;
      description = "Spaced repetition flashcard program";
      # Copy-pasted from the homepage
      longDescription = ''
        Anki is a program which makes remembering things easy. Because it is a lot
        more efficient than traditional study methods, you can either greatly
        decrease your time spent studying, or greatly increase the amount you learn.

        Anyone who needs to remember things in their daily life can benefit from
        Anki. Since it is content-agnostic and supports images, audio, videos and 
        scientific markup (via LaTeX), the possibilities are endless. For example:

        * learning a language
        * studying for medical and law exams
        * memorizing people's names and faces
        * brushing up on geography
        * mastering long poems
        * even practicing guitar chords!
      '';
      license = "GPLv3";
      platforms = stdenv.lib.platforms.all;
    };
}
