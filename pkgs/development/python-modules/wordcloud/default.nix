{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  matplotlib,
  numpy,
  pillow,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "wordcloud";
  version = "1.9.4";

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-snPYpd7ZfT6tkEBGtJRk3LcRGe5534dQcqTBBcrdNHo=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov --cov-report xml --tb=short" ""
  '';

  nativeBuildInputs = [ cython ];

  dependencies = [
    matplotlib
    numpy
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd test
  '';

  pythonImportsCheck = [ "wordcloud" ];

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
