{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, fetchpatch
, matplotlib
, mock
, numpy
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wordcloud";
  version = "unstable-2023-01-04";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amueller";
    repo = "word_cloud";
    rev = "dbf7ab7753a36e1c12c0e1b36aeeece5023f39f9";
    hash = "sha256-ogSkVcPUth7bh7mxwdDmF/Fc2ySDxbLA8ArmBNnPvw8=";
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
