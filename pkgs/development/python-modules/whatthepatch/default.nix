{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "whatthepatch";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cscorley";
    repo = "whatthepatch";
    tag = version;
    hash = "sha256-0pkkwVo9yaFEZyitfpKMC8EVr8HgPLUkrGWmyYOdZNE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "whatthepatch" ];

  meta = {
    description = "Python library for both parsing and applying patch files";
    homepage = "https://github.com/cscorley/whatthepatch";
    changelog = "https://github.com/cscorley/whatthepatch/blob/${version}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
