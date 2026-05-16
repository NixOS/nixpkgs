{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  matplotlib,
  numpy,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "wordcloud";
  version = "1.9.6";

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3xfEaP+QO9CrpPh8ZUB0XROkkxIg3Uk3yzY62FpHcbk=";
  };

  nativeBuildInputs = [ cython ];

  dependencies = [
    matplotlib
    numpy
    pillow
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

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

  meta = {
    description = "Word cloud generator in Python";
    mainProgram = "wordcloud_cli";
    homepage = "https://github.com/amueller/word_cloud";
    changelog = "https://github.com/amueller/word_cloud/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jm2dev ];
  };
}
