{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, odfpy
, openpyxl
, pandas
, setuptools-scm
, pytestCheckHook
, pytest-cov
, pyyaml
, unicodecsv
, xlrd
, xlwt
}:

buildPythonPackage rec {
  pname = "tablib";
  version = "3.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pX8ncLjCJf6+wcseZQEqac8w3Si+gQ4P+Y0CR2jH0PE=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ xlwt openpyxl pyyaml xlrd odfpy ];
  checkInputs = [ pytestCheckHook pytest-cov unicodecsv pandas ];

  # test_tablib needs MarkupPy, which isn't packaged yet
  pytestFlagsArray = [ "--ignore=tests/test_tablib.py" ];

  pythonImportsCheck = [ "tablib" ];

  meta = with lib; {
    description = "Format-agnostic tabular dataset library";
    homepage = "https://tablib.readthedocs.io/";
    changelog = "https://github.com/jazzband/tablib/raw/v${version}/HISTORY.md";
    license = licenses.mit;
  };
}
