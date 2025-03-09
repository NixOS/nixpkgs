{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  zconfig,
}:

buildPythonPackage rec {
  pname = "zdaemon";
  version = "5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Iun+UFDq67ngPZrWTk9jzNheBMOP2zUc8RO+9vaNt6Q=";
  };

  propagatedBuildInputs = [ zconfig ];

  # too many deps..
  doCheck = false;

  pythonImportsCheck = [ "zdaemon" ];

  meta = with lib; {
    description = "Daemon process control library and tools for Unix-based systems";
    mainProgram = "zdaemon";
    homepage = "https://pypi.python.org/pypi/zdaemon";
    changelog = "https://github.com/zopefoundation/zdaemon/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = [ ];
  };
}
