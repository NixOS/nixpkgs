{
  lib,
  stdenv,
  fetchzip,
  python311Packages,
  desktop-file-utils,
  freecell-solver,
  black-hole-solver,
  _experimental-update-script-combinators,
  gitUpdater,
}:

python311Packages.buildPythonApplication rec {
  pname = "pysolfc";
  version = "3.0.0";

  src = fetchzip {
    url = "mirror://sourceforge/pysolfc/PySolFC-${version}.tar.xz";
    hash = "sha256-LPOm83K4bdzmmQskmAnSyYpz+5y9ktQAhYCkXpODYKI=";
  };

  cardsets = stdenv.mkDerivation rec {
    pname = "pysol-cardsets";
    version = "3.0";

    src = fetchzip {
      url = "mirror://sourceforge/pysolfc/PySolFC-Cardsets-${version}.tar.bz2";
      hash = "sha256-UP0dQjoZJg+iSKVOrWbkLj1KCzMWws8ZBVSBLly1a/Y=";
    };

    installPhase = ''
      runHook preInstall
      cp -r $src $out
      runHook postInstall
    '';
  };

  music = stdenv.mkDerivation rec {
    pname = "pysol-music";
    version = "4.50";

    src = fetchzip {
      url = "mirror://sourceforge/pysolfc/pysol-music-${version}.tar.xz";
      hash = "sha256-sOl5U98aIorrQHJRy34s0HHaSW8hMUE7q84FMQAj5Yg=";
    };

    installPhase = ''
      runHook preInstall
      cp -r $src $out
      runHook postInstall
    '';
  };

  propagatedBuildInputs = with python311Packages; [
    tkinter
    six
    random2
    configobj
    pysol-cards
    attrs
    pycotap
    # optional :
    pygame
    freecell-solver
    black-hole-solver
    pillow
  ];

  patches = [ ./pysolfc-datadir.patch ];

  nativeBuildInputs = [ desktop-file-utils ];
  postPatch = ''
    desktop-file-edit --set-key Icon --set-value ${placeholder "out"}/share/icons/pysol01.png data/pysol.desktop
    desktop-file-edit --set-key Comment --set-value "${meta.description}" data/pysol.desktop
  '';

  postInstall = ''
    mkdir $out/share/PySolFC/cardsets
    cp -r $cardsets/* $out/share/PySolFC/cardsets
    cp -r $music/data/music $out/share/PySolFC
  '';

  # No tests in archive
  doCheck = false;

  passthru.updateScript = _experimental-update-script-combinators.sequence (
    # Needed in order to work around requirement that only one updater with features enabled is in sequence
    map (updater: updater.command) [
      (gitUpdater {
        url = "https://github.com/shlomif/PySolFC.git";
        rev-prefix = "pysolfc-";
      })
      (gitUpdater {
        url = "https://github.com/shlomif/PySolFC-CardSets.git";
        attrPath = "pysolfc.cardsets";
      })
      (gitUpdater {
        url = "https://github.com/shlomif/pysol-music.git";
        attrPath = "pysolfc.music";
      })
    ]
  );

  meta = with lib; {
    description = "A collection of more than 1000 solitaire card games";
    mainProgram = "pysol.py";
    homepage = "https://pysolfc.sourceforge.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
