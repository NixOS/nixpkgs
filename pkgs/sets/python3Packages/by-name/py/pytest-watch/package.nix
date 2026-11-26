{
  lib,
  buildPythonPackage,
  fetchPypi,
  docopt,
  colorama,
  pytest,
  watchdog,
}:

buildPythonPackage rec {
  pname = "pytest-watch";
  version = "4.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BhNvA9WzYXGLjQ0jQEL3svIDkQ2FaPY98vhmtUez1Lk=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    colorama
    docopt
    watchdog
  ];

  # No Tests
  doCheck = false;
  pythonImportsCheck = [ "pytest_watch" ];

  meta = {
    homepage = "https://github.com/joeyespo/pytest-watch";
    description = "Local continuous test runner with pytest and watchdog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dmvianna ];
  };
}
