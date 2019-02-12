{ stdenv
, buildPythonApplication
, callPackage
, lib
, python
, fetchurl
, fetchpatch
, fetchFromGitHub
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
, CoreAudio
# This little flag adds a huge number of dependencies, but we assume that
# everyone wants Anki to draw plots with statistics by default.
, plotsSupport ? true
# manual
, asciidoc
}:

let
    # when updating, also update rev-manual to a recent version of
    # https://github.com/dae/ankidocs
    # The manual is distributed independently of the software.
    version = "2.1.8";
    sha256-pkg = "08wb9hwpmbq7636h7sinim33qygdwwlh3frqqh2gfgm49f46di2p";
    rev-manual = "3a3d32dd9bfee6f5a7f5bdad2d70938874c881fa";
    sha256-manual = "1kz9ywbb6f42krxg8c5cwpjsnzm863vnkkn07szb3m1j85c10gjy";

    manual = stdenv.mkDerivation {
      name = "anki-manual-${version}";
      src = fetchFromGitHub {
        owner = "dae";
        repo = "ankidocs";
        rev = rev-manual;
        sha256 = sha256-manual;
      };
      phases = [ "unpackPhase" "patchPhase" "buildPhase" ];
      nativeBuildInputs = [ asciidoc ];
      patchPhase = ''
        # rsync isnt needed
        # WEB is the PREFIX
        # We remove any special ankiweb output generation
        # and rename every .mako to .html
        sed -e 's/rsync -a/cp -a/g' \
            -e "s|\$(WEB)/docs|$out/share/doc/anki/html|" \
            -e '/echo asciidoc/,/mv $@.tmp $@/c \\tasciidoc -b html5 -o $@ $<' \
            -e 's/\.mako/.html/g' \
            -i Makefile
        # patch absolute links to the other language manuals
        sed -e 's|https://apps.ankiweb.net/docs/|link:./|g' \
            -i {manual.txt,manual.*.txt}
        # there’s an artifact in most input files
        sed -e '/<%def.*title.*/d' \
            -i *.txt
        mkdir -p $out/share/doc/anki/html
      '';
    };

in
buildPythonApplication rec {
    name = "anki-${version}";

    src = fetchurl {
      urls = [
        "https://apps.ankiweb.net/downloads/current/${name}-source.tgz"
        # "https://apps.ankiweb.net/downloads/current/${name}-source.tgz"
        # "http://ankisrs.net/download/mirror/${name}.tgz"
        # "http://ankisrs.net/download/mirror/archive/${name}.tgz"
      ];
      sha256 = sha256-pkg;
    };

    outputs = [ "out" "doc" "man" ];

    propagatedBuildInputs = [
      pyqt5 sqlalchemy beautifulsoup4 send2trash pyaudio requests decorator
      markdown
    ]
      ++ lib.optional plotsSupport matplotlib
      ++ lib.optional stdenv.isDarwin [ CoreAudio ]
      ;

    checkInputs = [ pytest glibcLocales nose ];

    buildInputs = [ lame mplayer libpulseaudio  ];

    makeWrapperArgs = [
        ''--prefix PATH ':' "${lame}/bin:${mplayer}/bin"''
    ];

    patches = [
      # Disable updated version check.
      ./no-version-check.patch
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

      # hitting F1 should open the local manual
      substituteInPlace anki/consts.py \
        --replace 'HELP_SITE="http://ankisrs.net/docs/manual.html"' \
                  'HELP_SITE="${manual}/share/doc/anki/html/manual.html"'
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
      mkdir -p $doc/share/doc/anki
      mkdir -p $man/share/man/man1
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
      cp -v README* LICENSE* $doc/share/doc/anki/
      cp -v anki.1 $man/share/man/man1/
      cp -v anki.xml $out/share/mime/packages/
      cp -v anki.{png,xpm} $out/share/pixmaps/
      cp -rv locale $out/share/
      cp -rv anki aqt web $pp/

      wrapPythonPrograms

      # copy the manual into $doc
      cp -r ${manual}/share/doc/anki/html $doc/share/doc/anki
    '';

    passthru = {
      inherit manual;
    };

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
      maintainers = with maintainers; [ the-kenny Profpatsch ];
    };
}
