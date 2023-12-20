{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, packaging
, pyxdg
}:

buildPythonPackage rec {
  pname = "show-in-file-manager";
  version = "1.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FdFuSodbniF7A40C8CnDgAxKatZF4/c8nhB+omurOts=";
  };

  propagatedBuildInputs = [
    packaging
  ]
  ++ lib.optional (stdenv.isLinux) pyxdg
  ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  meta = with lib; {
    homepage = "https://github.com/damonlynch/showinfilemanager";
    description = "Open the system file manager and select files in it";
    longDescription = ''
      Show in File Manager is a Python package to open the system file
      manager and optionally select files in it. The point is not to
      open the files, but to select them in the file manager, thereby
      highlighting the files and allowing the user to quickly do
      something with them.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
