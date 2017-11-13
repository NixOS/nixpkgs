{ stdenv
, buildPythonPackage
, callPackage
, lib
, python
, fetchurl
, substituteAll
, lame
, mplayer
, libpulseaudio
, pyqt4
, sqlalchemy
, pyaudio
, httplib2
, matplotlib
, pytest
, glibcLocales
, nose
# This little flag adds a huge number of dependencies, but we assume that
# everyone wants Anki to draw plots with statistics by default.
, plotsSupport ? true
}:

let
    # Development version of anki has bumped to beautifulsoup4
    beautifulsoup = callPackage ./beautifulsoup.nix { };

    qt4 = pyqt4.qt;

in buildPythonPackage rec {
    version = "2.0.47";
    name = "anki-${version}";

    src = fetchurl {
      urls = [
        "https://apps.ankiweb.net/downloads/current/${name}-source.tgz"
        # "http://ankisrs.net/download/mirror/${name}.tgz"
        # "http://ankisrs.net/download/mirror/archive/${name}.tgz"
      ];
      sha256 = "067bsidqzy1zc301i2pk4biwp2kwvgk4kydp5z5s551acinkbdgv";
    };

    propagatedBuildInputs = [ pyqt4 sqlalchemy pyaudio beautifulsoup httplib2 ]
                            ++ lib.optional plotsSupport matplotlib;

    checkInputs = [ pytest glibcLocales nose ];

    buildInputs = [ lame mplayer libpulseaudio  ];

    patches = [
      # Disable updated version check.
      ./no-version-check.patch

      (substituteAll {
        src = ./fix-paths.patch;
        inherit lame mplayer qt4;
        qt4name = qt4.name;
      })
    ];

    buildPhase = ''
      # Dummy build phase
      # Anki does not use setup.py
    '';

    postPatch = ''
      substituteInPlace oldanki/lang.py --subst-var-by anki $out
      substituteInPlace anki/lang.py --subst-var-by anki $out

      # Remove unused starter. We'll create our own, minimalistic,
      # starter.
      rm anki/anki

      # Remove QT translation files. We'll use the standard QT ones.
      rm "locale/"*.qm
    '';

    # UTF-8 locale needed for testing
    LC_ALL = "en_US.UTF-8";

    checkPhase = ''
      # - Anki writes some files to $HOME during tests
      # - Skip tests using network
      env HOME=$TMP pytest --ignore tests/test_sync.py
    '';

    installPhase = ''
      pp=$out/lib/${python.libPrefix}/site-packages

      mkdir -p $out/bin
      mkdir -p $out/share/applications
      mkdir -p $out/share/doc/anki
      mkdir -p $out/share/man/man1
      mkdir -p $out/share/mime/packages
      mkdir -p $out/share/pixmaps
      mkdir -p $pp

      cat > $out/bin/anki <<EOF
      #!${python}/bin/python
      import aqt
      aqt.run()
      EOF
      chmod 755 $out/bin/anki

      cp -v anki.desktop $out/share/applications/
      cp -v README* LICENSE* $out/share/doc/anki/
      cp -v anki.1 $out/share/man/man1/
      cp -v anki.xml $out/share/mime/packages/
      cp -v anki.{png,xpm} $out/share/pixmaps/
      cp -rv locale $out/share/
      cp -rv anki aqt thirdparty/send2trash $pp/

      wrapPythonPrograms
    '';

    meta = with stdenv.lib; {
      homepage = http://ankisrs.net/;
      description = "Spaced repetition flashcard program";
      license = licenses.gpl3;

      longDescription = ''
        Anki is a program which makes remembering things easy. Because it is a lot
        more efficient than traditional study methods, you can either greatly
        decrease your time spent studying, or greatly increase the amount you learn.

        Anyone who needs to remember things in their daily life can benefit from
        Anki. Since it is content-agnostic and supports images, audio, videos and
        scientific markup (via LaTeX), the possibilities are endless. For example:
        learning a language, studying for medical and law exams, memorizing
        people's names and faces, brushing up on geography, mastering long poems,
        or even practicing guitar chords!
      '';

      maintainers = with maintainers; [ the-kenny ];
      platforms = platforms.mesaPlatforms;
    };
}
