{ stdenv
, buildPythonApplication
, callPackage
, lib
, python
, fetchurl
, fetchpatch
, lame
, mplayer
, libpulseaudio
, pyqt5
, decorator
, beautifulsoup4
, sqlalchemy
, pyaudio
, requests
, markdown
, matplotlib
, pytest
, glibcLocales
, nose
, send2trash
# This little flag adds a huge number of dependencies, but we assume that
# everyone wants Anki to draw plots with statistics by default.
, plotsSupport ? true
}:

buildPythonApplication rec {
    version = "2.1.6-beta2";
    name = "anki-${version}";

    src = fetchurl {
      urls = [
        "https://apps.ankiweb.net/downloads/beta/${name}-source.tgz"
        # "https://apps.ankiweb.net/downloads/current/${name}-source.tgz"
        # "http://ankisrs.net/download/mirror/${name}.tgz"
        # "http://ankisrs.net/download/mirror/archive/${name}.tgz"
      ];
      sha256 = "0h71s1j1269x0b8481z8xf019caqglcjs32xlpzk72087ps169fa";
    };

    propagatedBuildInputs = [ pyqt5 sqlalchemy
      beautifulsoup4 send2trash pyaudio requests decorator markdown ]
                            ++ lib.optional plotsSupport matplotlib;

    checkInputs = [ pytest glibcLocales nose ];

    buildInputs = [ lame mplayer libpulseaudio  ];

    makeWrapperArgs = [
        ''--prefix PATH ':' "${lame}/bin:${mplayer}/bin"''
    ];

    patches = [
      # Disable updated version check.
      ./no-version-check.patch

      # This is needed to fix python 3.7 compatibilty, where the
      # behaviour of `re.escape()` was changed in a way that it no
      # longer escapes `%`. This patch detects this difference at
      # runtime and makes anki work with any python version.
      # Upstream PR: https://github.com/dae/anki/pull/266
      (fetchpatch {
        url = "https://github.com/dae/anki/commit/3d69aa9ce454a151ba75deafd7de117af2c7307d.patch";
        sha256 = "0kf9gajhy0wcajp24xfia71z6gn1mc4vl37svvq4sqbhj3gigd0h";
      })
    ];

    buildPhase = ''
      # Dummy build phase
      # Anki does not use setup.py
    '';

    postPatch = ''
      # Remove unused starter. We'll create our own, minimalistic,
      # starter.
      # rm anki/anki

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
      cp -rv anki aqt web $pp/

      wrapPythonPrograms
    '';

    meta = with stdenv.lib; {
      homepage = "https://apps.ankiweb.net/";
      description = "Spaced repetition flashcard program";
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
      license = licenses.agpl3Plus;
      broken = stdenv.hostPlatform.isAarch64;
      platforms = platforms.mesaPlatforms;
      maintainers = with maintainers; [ the-kenny ];
    };
}
