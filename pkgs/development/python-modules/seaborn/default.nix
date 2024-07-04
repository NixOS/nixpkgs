{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  matplotlib,
  pytest-xdist,
  pytestCheckHook,
  numpy,
  pandas,
  pythonOlder,
  scipy,
  statsmodels,
}:

buildPythonPackage rec {
  pname = "seaborn";
  version = "0.13.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mwaskom";
    repo = "seaborn";
    rev = "refs/tags/v${version}";
    hash = "sha256-aGIVcdG/XN999nYBHh3lJqGa3QVt0j8kmzaxdkULznY=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
  ];

  passthru.optional-dependencies = {
    stats = [
      scipy
      statsmodels
    ];
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests =
    [
      # requires internet connection
      "test_load_dataset_string_error"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isx86) [
      # overly strict float tolerances
      "TestDendrogram"
    ];

  # All platforms should use Agg. Let's set it explicitly to avoid probing GUI
  # backends (leads to crashes on macOS).
  env.MPLBACKEND = "Agg";

  pythonImportsCheck = [ "seaborn" ];

  meta = with lib; {
    description = "Statistical data visualization";
    homepage = "https://seaborn.pydata.org/";
    changelog = "https://github.com/mwaskom/seaborn/blob/master/doc/whatsnew/${src.rev}.rst";
    license = with licenses; [ bsd3 ];
  };
}
