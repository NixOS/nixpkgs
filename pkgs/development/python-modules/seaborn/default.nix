{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
    tag = "v${version}";
    hash = "sha256-aGIVcdG/XN999nYBHh3lJqGa3QVt0j8kmzaxdkULznY=";
  };

  patches = [
    # https://github.com/mwaskom/seaborn/pull/3685
    (fetchpatch2 {
      name = "numpy_2-compatibility.patch";
      url = "https://github.com/mwaskom/seaborn/commit/58f170fe799ef496adae19925d7d4f0f14f8da95.patch";
      hash = "sha256-/a3G+kNIRv8Oa4a0jPGnL2Wvx/9umMoiq1BXcXpehAg=";
    })
    # https://github.com/mwaskom/seaborn/pull/3802
    (fetchpatch2 {
      name = "matplotlib_3_10-compatibility.patch";
      url = "https://github.com/mwaskom/seaborn/commit/385e54676ca16d0132434bc9df6bc41ea8b2a0d4.patch";
      hash = "sha256-nwGwTkP7W9QzgbbAVdb2rASgsMxqFnylMk8GnTE445w=";
    })
  ];

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
  ];

  optional-dependencies = {
    stats = [
      scipy
      statsmodels
    ];
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
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
