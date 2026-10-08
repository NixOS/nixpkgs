{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  stockfish,
}:

buildPythonPackage (finalAttrs: {
  pname = "stockfish";
  version = "5.2.0";
  pyproject = true;

  # The PyPI sdist does not ship the test suite
  src = fetchFromGitHub {
    owner = "py-stockfish";
    repo = "stockfish";
    tag = finalAttrs.version;
    hash = "sha256-YdT7O00U9V7zEwIqDdwQ+FSL6xu/7lAXj53aT4IldEQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    stockfish
  ];

  # Upstream enables coverage reporting through addopts, which is not useful here
  pytestFlags = [
    "-o"
    "addopts="
  ];

  disabledTests = [
    # These search with a wall-clock time budget, so the move they settle on
    # depends on how fast the machine is
    # https://github.com/py-stockfish/stockfish/issues/17
    "test_get_best_move_remaining_time_first_move"
    "test_get_best_move_remaining_time_not_first_move"
  ];

  pythonImportsCheck = [ "stockfish" ];

  meta = {
    description = "Integrates the Stockfish chess engine with Python";
    homepage = "https://github.com/py-stockfish/stockfish";
    changelog = "https://github.com/py-stockfish/stockfish/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamerrq ];
  };
})
