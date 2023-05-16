{ lib
, buildPythonPackage
, fetchPypi
, markuppy
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
<<<<<<< HEAD
  version = "3.5.0";
=======
  version = "3.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-9mYd/EXh1PUfqKYjn5yDSTgIWaW/qnMoBkXwRtbJbjM=";
=======
    hash = "sha256-d+qX+vb5Kn4ZjAW9DGkPPLpXuD6kWmNrcvlny2/m8WA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
      markuppy
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
      markuppy
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

  nativeCheckInputs = [
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
