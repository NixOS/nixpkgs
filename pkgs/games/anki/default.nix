{ stdenv, lib, fetchurl, lame, mplayer, pulseaudio, portaudio
, python, pyqt4, pythonPackages
# This little flag adds a huge number of dependencies, but we assume that
# everyone wants Anki to draw plots with statistics by default.
, plotsSupport ? true }:

let
    py = pythonPackages;
in

stdenv.mkDerivation rec {
    name = "anki-2.0.20";
    src = fetchurl {
      url = "http://ankisrs.net/download/mirror/${name}.tgz";
      sha256 = "1w274g7as458bfkh86635p04fimvmkn70j8qy9m6nl2xwjaq8nhm";
    };

    pythonPath = [ pyqt4 py.pysqlite py.sqlalchemy py.pyaudio ]
              ++ lib.optional plotsSupport py.matplotlib;

    buildInputs = [ python py.wrapPython lame mplayer pulseaudio ];

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
      mkdir -p "$out/lib/${python.libPrefix}/site-packages"
      ln -s $out/share/anki/* $out/lib/${python.libPrefix}/site-packages/
      export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
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
      maintainers = with stdenv.lib.maintainers; [ the-kenny ];
      platforms = stdenv.lib.platforms.mesaPlatforms;
    };
}
