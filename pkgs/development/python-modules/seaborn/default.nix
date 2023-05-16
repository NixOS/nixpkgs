{ lib
, stdenv
, buildPythonPackage
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, flit-core
, matplotlib
, pytest-xdist
, pytestCheckHook
, numpy
, pandas
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "seaborn";
  version = "0.12.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N0ZF82UJ0NyriVy6W0fa8Fhvd7/js2yXxgfbfaW+ATk=";
  };

<<<<<<< HEAD
  patches = [
    (fetchpatch {
      name = "fix-test-using-matplotlib-3.7.patch";
      url = "https://github.com/mwaskom/seaborn/commit/db7ae11750fc2dfb695457239708448d54e9b8cd.patch";
      hash = "sha256-LbieI0GeC/0NpFVxV/NRQweFjP/lj/TR2D/SLMPYqJg=";
    })
    (fetchpatch {
      name = "fix-pandas-deprecation.patch";
      url = "https://github.com/mwaskom/seaborn/commit/a48601d6bbf8381f9435be48624f1a77d6fbfced.patch";
      hash = "sha256-LuN8jn6Jo9Fvdl5iGZ2LgINYujSDvvs+hSclnadV1F4=";
    })
    (fetchpatch {
      name = "fix-tests-using-numpy-1.25.patch";
      url = "https://github.com/mwaskom/seaborn/commit/b6737d5aec9a91bb8840cdda896a7970e1830d56.patch";
      hash = "sha256-Xj82yyB5Vy2xKRl0ideDmJ5Zr4Xc+8cEHU/liVwMSvE=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
<<<<<<< HEAD
    # requires internet connection
    "test_load_dataset_string_error"

    # per https://github.com/mwaskom/seaborn/issues/3431, we can enable this
    # once matplotlib releases version > 3.7.2
    "test_share_xy"
=======
    # incompatible with matplotlib 3.7
    # https://github.com/mwaskom/seaborn/issues/3288
    "test_subplot_kws"

    # requires internet connection
    "test_load_dataset_string_error"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals (!stdenv.hostPlatform.isx86) [
    # overly strict float tolerances
    "TestDendrogram"
  ];

  # All platforms should use Agg. Let's set it explicitly to avoid probing GUI
  # backends (leads to crashes on macOS).
<<<<<<< HEAD
  env.MPLBACKEND="Agg";
=======
  MPLBACKEND="Agg";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
