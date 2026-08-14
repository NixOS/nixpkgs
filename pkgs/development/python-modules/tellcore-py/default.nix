{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tellcore-py";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erijo";
    repo = "tellcore-py";
    tag = "v${version}";
    hash = "sha256-AcdYMzd3Ln65PZ+weSxyR+CwXmdi2A+wSE6B/4hepE0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tellcore" ];

  meta = {
    description = "Python wrapper for Telldus' home automation library";
    homepage = "https://github.com/erijo/tellcore-py";
    changelog = "https://github.com/erijo/tellcore-py/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
