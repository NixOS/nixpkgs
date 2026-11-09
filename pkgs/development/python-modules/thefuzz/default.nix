{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  hypothesis,
  levenshtein,
  setuptools,
}:

buildPythonPackage rec {
  pname = "thefuzz";
  version = "0.22.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cTgDmn7PVA2jI3kthZLvmQKx1563jBR9TyBmTeefNoA=";
  };

  # Skip linting
  postPatch = ''
    substituteInPlace test_thefuzz.py \
      --replace-fail "import pycodestyle" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ levenshtein ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  optional-dependencies = {
    speedup = [ ];
  };

  pythonImportsCheck = [ "thefuzz" ];

  disabledTests = [
    # Skip linting
    "test_pep8_conformance"
  ];

  meta = {
    description = "Fuzzy string matching for Python";
    homepage = "https://github.com/seatgeek/thefuzz";
    changelog = "https://github.com/seatgeek/thefuzz/blob/${version}/CHANGES.rst";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sumnerevans ];
  };
}
