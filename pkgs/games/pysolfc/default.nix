{ lib
, fetchzip
, buildPythonApplication
, python3Packages
, desktop-file-utils
, freecell-solver
}:

buildPythonApplication rec {
  pname = "pysolfc";
  version = "2.21.0";

  src = fetchzip {
    url = "mirror://sourceforge/pysolfc/PySolFC-${version}.tar.xz";
    hash = "sha256-Deye7KML5G6RZkth2veVgPOWZI8gnusEvszlrPTAhag=";
  };

  cardsets = fetchzip {
    url = "mirror://sourceforge/pysolfc/PySolFC-Cardsets-2.2.tar.bz2";
    hash = "sha256-mWJ0l9rvn9KeZ9rCWy7VjngJzJtSQSmG8zGcYFE4yM0=";
  };

  music = fetchzip {
    url = "mirror://sourceforge/pysolfc/pysol-music-4.50.tar.xz";
    hash = "sha256-sOl5U98aIorrQHJRy34s0HHaSW8hMUE7q84FMQAj5Yg=";
  };

  propagatedBuildInputs = with python3Packages; [
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
    pillow
  ];

  patches = [
    ./pysolfc-datadir.patch
  ];

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

  meta = with lib; {
    description = "A collection of more than 1000 solitaire card games";
    mainProgram = "pysol.py";
    homepage = "https://pysolfc.sourceforge.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kierdavis ];
  };
}
