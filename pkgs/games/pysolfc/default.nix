{ stdenv, fetchzip, buildPythonApplication, python3Packages
  , desktop-file-utils, freecell-solver }:

buildPythonApplication rec {
  pname = "PySolFC";
  version = "2.6.4";

  src = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySolFC/PySolFC-${version}/PySolFC-${version}.tar.xz";
    sha256 = "1bd84law5b1yga3pryggdvlfvm0l62gci2q8y3q79cysdk3z4w3z";
  };

  cardsets = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySolFC-Cardsets/PySolFC-Cardsets-2.0/PySolFC-Cardsets-2.0.tar.bz2";
    sha256 = "0h0fibjv47j8lkc1bwnlbbvrx2nr3l2hzv717kcgagwhc7v2mrqh";
  };

  propagatedBuildInputs = with python3Packages; [
    tkinter six random2
    # optional :
    pygame freecell-solver pillow
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
  '';

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A collection of more than 1000 solitaire card games";
    homepage = https://pysolfc.sourceforge.io;
    license = licenses.gpl3;
    maintainers = with maintainers; [ kierdavis genesis ];
  };
}
