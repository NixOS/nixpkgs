{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ipython,
  matplotlib,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "summarytools";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m29ug+JZC4HgMIVopovA/dyR40Z1IcADOiDWKg9mzdc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipython
    matplotlib
    numpy
    pandas
  ];

  pythonImportsCheck = [ "summarytools" ];

  meta = with lib; {
    description = "Python port of the R summarytools package for summarizing dataframes";
    homepage = "https://github.com/6chaoran/jupyter-summarytools";
    changelog = "https://github.com/6chaoran/jupyter-summarytools/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
