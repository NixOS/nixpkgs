{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pygobject3,
  dbus-python,
}:

buildPythonPackage rec {
  pname = "trayer";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S8KGbp4cs/xgjzIsLkpcw2odbBT8hw0gzEeg+iW045Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pygobject3
    dbus-python
  ];

  pythonImportsCheck = [ "trayer" ];

  meta = {
    description = "Tray library for python";
    homepage = "https://github.com/Enne2/trayer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinso ];
  };
}
