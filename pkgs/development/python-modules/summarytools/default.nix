{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ipython,
  matplotlib,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "summarytools";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q5A2jayv9Mb3KKRNXRMydZbokLWdzC4JmsMijqp/0J0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipython
    matplotlib
    numpy
    pandas
  ];

  pythonImportsCheck = [ "summarytools" ];

  meta = {
    description = "Python port of the R summarytools package for summarizing dataframes";
    homepage = "https://github.com/6chaoran/jupyter-summarytools";
    changelog = "https://github.com/6chaoran/jupyter-summarytools/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
