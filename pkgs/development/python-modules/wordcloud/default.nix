{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, matplotlib
, mock
, numpy
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wordcloud";
  version = "1.9.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amueller";
    repo = "word_cloud";
    rev = "refs/tags/${version}";
    hash = "sha256-Tcle9otT1eBN/RzajwKZDUq8xX0Lhi2t74OvhUrvHZE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov --cov-report xml --tb=short" ""
  '';

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

  preCheck = ''
    cd test
  '';

  pythonImportsCheck = [
    "wordcloud"
  ];

  disabledTests = [
    # Don't tests CLI
    "test_cli_as_executable"
    # OSError: invalid ppem value
    "test_recolor_too_small"
    "test_coloring_black_works"
  ];

  meta = with lib; {
    description = "Word cloud generator in Python";
    homepage = "https://github.com/amueller/word_cloud";
    changelog = "https://github.com/amueller/word_cloud/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
