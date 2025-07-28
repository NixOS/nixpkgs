{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  setuptools-scm,
  packaging,
  tomli,

  # tests
  poppler-qt5,
  qgis,
  qgis-ltr,
}:

buildPythonPackage rec {
  pname = "sip";
  version = "6.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+gUVaX1MmNvgTZ6JjYFt4UJ+W5rl0OFSFpEJ/SH10pw=";
  };

  patches = [
    # Make wheel file generation deterministic https://github.com/NixOS/nixpkgs/issues/383885
    ./sip-builder.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    setuptools
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "sipbuild" ];

  passthru.tests = {
    # test depending packages
    inherit poppler-qt5 qgis qgis-ltr;
  };

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
