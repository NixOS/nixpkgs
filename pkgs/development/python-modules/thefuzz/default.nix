{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  hypothesis,
  levenshtein,
  setuptools,
}:

buildPythonPackage rec {
  pname = "thefuzz";
  version = "0.22.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Fuzzy string matching for Python";
    homepage = "https://github.com/seatgeek/thefuzz";
    changelog = "https://github.com/seatgeek/thefuzz/blob/${version}/CHANGES.rst";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
