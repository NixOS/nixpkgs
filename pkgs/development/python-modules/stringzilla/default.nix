{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  numpy,
  pytest-repeat,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stringzilla";
  version = "4.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "stringzilla";
    tag = "v${version}";
    hash = "sha256-PAs5j+J3BH23Yk2K0tYvCmz7cTU4djePzUpjsCk8YZs=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "stringzilla" ];

  nativeCheckInputs = [
    numpy
    pytest-repeat
    pytestCheckHook
  ];

  enabledTestPaths = [ "scripts/test_stringzilla.py" ];

  meta = {
    changelog = "https://github.com/ashvardanian/StringZilla/releases/tag/${src.tag}";
    description = "SIMD-accelerated string search, sort, hashes, fingerprints, & edit distances";
    homepage = "https://github.com/ashvardanian/stringzilla";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aciceri
      dotlambda
    ];
  };
}
