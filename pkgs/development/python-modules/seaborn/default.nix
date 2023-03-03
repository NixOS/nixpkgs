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

  nativeCheckInputs = [
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

    # requires internet connection
    "test_load_dataset_string_error"
  ] ++ lib.optionals (!stdenv.hostPlatform.isx86) [
    # overly strict float tolerances
    "TestDendrogram"
  ];

  # All platforms should use Agg. Let's set it explicitly to avoid probing GUI
  # backends (leads to crashes on macOS).
  MPLBACKEND="Agg";

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
