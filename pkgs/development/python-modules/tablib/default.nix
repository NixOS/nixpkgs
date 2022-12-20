{ lib
, buildPythonPackage
, fetchPypi
, odfpy
, openpyxl
, pandas
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools-scm
, tabulate
, unicodecsv
, xlrd
, xlwt
}:

buildPythonPackage rec {
  pname = "tablib";
  version = "3.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pX8ncLjCJf6+wcseZQEqac8w3Si+gQ4P+Y0CR2jH0PE=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov=tablib --cov=tests --cov-report xml --cov-report term --cov-report html" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    all = [
      # markuppy
      odfpy
      openpyxl
      pandas
      pyyaml
      tabulate
      xlrd
      xlwt
    ];
    cli = [
      tabulate
    ];
    html = [
      # markuppy
    ];
    ods = [
      odfpy
    ];
    pandas = [
      pandas
    ];
    xls = [
      xlrd
      xlwt
    ];
    xlsx = [
      openpyxl
    ];
    yaml = [
      pyyaml
    ];
  };

  checkInputs = [
    pandas
    pytestCheckHook
    unicodecsv
  ];

  disabledTestPaths = [
    # test_tablib needs MarkupPy, which isn't packaged yet
    "tests/test_tablib.py"
  ];

  pythonImportsCheck = [
    "tablib"
  ];

  meta = with lib; {
    description = "Format-agnostic tabular dataset library";
    homepage = "https://tablib.readthedocs.io/";
    changelog = "https://github.com/jazzband/tablib/raw/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
