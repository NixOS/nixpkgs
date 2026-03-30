{
  lib,
  buildPythonPackage,
  fetchurl,
  python,
  sphinx,
  xapian,
}:

let
  pythonSuffix = lib.optionalString python.isPy3k "3";
in
buildPythonPackage rec {
  pname = "xapian";
  inherit (xapian) version;
  pyproject = false;

  src = fetchurl {
    url = "https://oligarchy.co.uk/xapian/${version}/xapian-bindings-${version}.tar.xz";
    hash = "sha256-ujteEICeV5rNEb0WV3nOP9KaiQTqN5aO9bV62Xw2GLo=";
  };

  configureFlags = [
    "--with-python${pythonSuffix}"
    "PYTHON${pythonSuffix}_LIB=${placeholder "out"}/${python.sitePackages}"
  ];

  preConfigure = ''
    export XAPIAN_CONFIG=${xapian}/bin/xapian-config
  '';

  buildInputs = [
    sphinx
    xapian
  ];

  checkPhase = ''
    ${python.interpreter} python${pythonSuffix}/pythontest.py
  '';

  meta = {
    description = "Python Bindings for Xapian";
    homepage = "https://xapian.org/";
    changelog = "https://xapian.org/docs/xapian-bindings-${version}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}
