{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, flit-core
, matplotlib
, pytestCheckHook
, numpy
, pandas
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "seaborn";
  version = "0.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ux6x1R0wlzaMGHw+8InAKI7B/oqhxp+zJMaKodAt9ME=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    scipy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # incompatible with matplotlib 3.5
    "TestKDEPlotBivariate"
    "TestBoxPlotter"
    "TestCatPlot"
    "TestKDEPlotUnivariate"
    "test_with_rug"
    "test_bivariate_kde_norm"
  ] ++ lib.optionals (!stdenv.hostPlatform.isx86) [
    # overly strict float tolerances
    "TestDendrogram"
  ];

  pythonImportsCheck = [
    "seaborn"
  ];

  meta = with lib; {
    description = "Statistical data visualization";
    homepage = "https://seaborn.pydata.org/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fridh ];
  };
}
