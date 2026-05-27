{
  lib,
  fetchPypi,
  buildPythonPackage,
  requests,
}:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "8.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rkg6eSLiQe8DZaVu2DEnlKLe8RLkRwKmpw+TaYj+lp0=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "todoist" ];

  meta = {
    description = "Official Todoist Python API library";
    homepage = "https://todoist-python.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
