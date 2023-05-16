{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, matplotlib
, mock
, numpy
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wordcloud";
<<<<<<< HEAD
  version = "1.9.1.1";
=======
  version = "unstable-2023-01-04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amueller";
    repo = "word_cloud";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-Tcle9otT1eBN/RzajwKZDUq8xX0Lhi2t74OvhUrvHZE=";
=======
    rev = "dbf7ab7753a36e1c12c0e1b36aeeece5023f39f9";
    hash = "sha256-ogSkVcPUth7bh7mxwdDmF/Fc2ySDxbLA8ArmBNnPvw8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pillow
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov --cov-report xml --tb=short" ""
  '';

  preCheck = ''
    cd test
  '';

  pythonImportsCheck = [
    "wordcloud"
  ];

  disabledTests = [
    # Don't tests CLI
    "test_cli_as_executable"
  ];

  meta = with lib; {
    description = "Word cloud generator in Python";
    homepage = "https://github.com/amueller/word_cloud";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
