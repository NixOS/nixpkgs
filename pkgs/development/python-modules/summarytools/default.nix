{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, ipython
, matplotlib
, numpy
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "summarytools";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  # no version tags in GitHub repo
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m29ug+JZC4HgMIVopovA/dyR40Z1IcADOiDWKg9mzdc=";
  };

  nativeBuildInputs = [ setuptools ];

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
