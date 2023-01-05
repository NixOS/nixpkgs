{ lib, fetchPypi, buildPythonPackage
, python3Packages
}:

buildPythonPackage rec {
  pname = "show-in-file-manager";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "FdFuSodbniF7A40C8CnDgAxKatZF4/c8nhB+omurOts=";
  };

  buildInputs = with python3Packages; [
    pyxdg
    packaging
  ];
  doCheck = false;

  meta = with lib; {
    description = "Python package to open the system file manager and optionally select files in it.";
    homepage = "https://github.com/damonlynch/showinfilemanager";
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
