{ lib, buildPythonPackage, fetchurl, python
, sphinx
, xapian
}:

let
  pythonSuffix = lib.optionalString python.isPy3k "3";
in
buildPythonPackage rec {
  pname = "xapian";
  inherit (xapian) version;
  format = "other";

  src = fetchurl {
    url = "https://oligarchy.co.uk/xapian/${version}/xapian-bindings-${version}.tar.xz";
    sha256 = "0j9awiiw9zf97r60m848absq43k37gghpyw7acxqjazfzd71fxvm";
  };

  configureFlags = [
    "--with-python${pythonSuffix}"
    "PYTHON${pythonSuffix}_LIB=${placeholder "out"}/${python.sitePackages}"
  ];

  preConfigure = ''
    export XAPIAN_CONFIG=${xapian}/bin/xapian-config
  '';

  buildInputs = [ sphinx xapian ];

  doCheck = true;

  checkPhase = ''
    ${python.interpreter} python${pythonSuffix}/pythontest.py
  '';

  meta = with lib; {
    description = "Python Bindings for Xapian";
    homepage = "https://xapian.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jonringer ];
  };
}
