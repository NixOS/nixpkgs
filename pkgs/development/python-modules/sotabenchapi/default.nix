{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  requests,
  tabulate,
}:

let
  version = "0.0.16";
  pname = "sotabenchapi";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-thbVH4aLmEgi8K17PkmbUg4nHqGj+dEiXPDILjvQMzk=";
  };

  # requirements.txt is missing in the Pypi archive and this makes the setup.py script fails
  postPatch = ''
    touch requirements.txt
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    requests
    tabulate
  ];

  pythonImportsCheck = [
    "sotabenchapi"
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Easily benchmark Machine Learning models on selected tasks and datasets";
    homepage = "https://pypi.org/project/sotabenchapi/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
