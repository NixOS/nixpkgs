{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, ipython
, matplotlib
, numpy
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "summarytools";
  version = "0.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  # no version tags in GitHub repo
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wsDf9IXCMQe0cVfQQuRVwMhxkhhUxbPu06yWZPLvgw4=";
  };

  propagatedBuildInputs = [
    ipython
    matplotlib
    numpy
    pandas
  ];

  nativeCheckImports = [ pytestCheckHook ];
  pythonImportsCheck = [ "summarytools" ];

  meta = with lib; {
    description = "Python port of the R summarytools package for summarizing dataframes";
    homepage = "https://github.com/6chaoran/jupyter-summarytools";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
