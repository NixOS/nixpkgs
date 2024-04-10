{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, matplotlib
, numpy
, pillow
, pytestCheckHook
, pythonOlder
, setuptools-scm
, python
}:

buildPythonPackage rec {
  pname = "wordcloud";
  version = "1.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amueller";
    repo = "word_cloud";
    rev = "refs/tags/${version}";
    hash = "sha256-UbryGiu1AW6Razbf4BJIKGKKhG6JOeZUGb1k0w8f8XA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-warn " --cov --cov-report xml --tb=short" ""
  '';

  nativeBuildInputs = [
    cython
    setuptools-scm
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pillow
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postInstall = ''
    cp ${src}/wordcloud/stopwords $out/${python.sitePackages}/wordcloud/stopwords
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
    # OSError: invalid ppem value
    "test_recolor_too_small"
    "test_coloring_black_works"
  ];

  meta = with lib; {
    description = "Word cloud generator in Python";
    mainProgram = "wordcloud_cli";
    homepage = "https://github.com/amueller/word_cloud";
    changelog = "https://github.com/amueller/word_cloud/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
