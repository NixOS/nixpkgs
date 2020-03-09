{ stdenv, fetchzip, buildPythonApplication, python3Packages
, freecell-solver }:

buildPythonApplication rec {
  pname = "PySolFC";
  version = "2.8.0";

  src = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySolFC/PySolFC-${version}/PySolFC-${version}.tar.xz";
    sha256 = "01j7lyp7hbybmvph2ww67a6jp455a5ln7pzbs9d1762r323yz5sy";
  };

  cardsets = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySolFC-Cardsets/PySolFC-Cardsets-2.0/PySolFC-Cardsets-2.0.tar.bz2";
    sha256 = "0h0fibjv47j8lkc1bwnlbbvrx2nr3l2hzv717kcgagwhc7v2mrqh";
  };

  postPatch = ''
    sed -i s:/usr/share/PySolFC:$out/share/PySolFC: pysollib/settings.py
  '';

  dontUseSetuptoolsCheck = true;

  propagatedBuildInputs = with python3Packages; [
    attrs configobj six random2 pysol_cards pycotap tkinter
    #  optional :
    pygame freecell-solver pillow
  ];

  postInstall = ''
    mkdir $out/share/PySolFC/cardsets
    cp -r $cardsets/* $out/share/PySolFC/cardsets
  '';

  meta = with stdenv.lib; {
    description = "A collection of more than 1000 solitaire card games";
    homepage = https://pysolfc.sourceforge.io;
    license = licenses.gpl3;
    maintainers = with maintainers; [ kierdavis genesis ];
  };
}
