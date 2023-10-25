{ lib
, fetchzip
, buildPythonApplication
, python3Packages
, desktop-file-utils
, freecell-solver
}:

buildPythonApplication rec {
  pname = "PySolFC";
  version = "2.20.1";

  src = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySolFC/PySolFC-${version}/PySolFC-${version}.tar.xz";
    hash = "sha256-mEnsq8Su0ses+nqoSFC+Wr0MHY7aTDMbtDV8toYVNPY=";
  };

  cardsets = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySolFC-Cardsets/PySolFC-Cardsets-2.2/PySolFC-Cardsets-2.2.tar.bz2";
    hash = "sha256-mWJ0l9rvn9KeZ9rCWy7VjngJzJtSQSmG8zGcYFE4yM0=";
  };

  music = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySol-Music/PySol-Music-4.50/pysol-music-4.50.tar.xz";
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
    homepage = "https://pysolfc.sourceforge.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kierdavis ];
  };
}
