{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "sipyco";
  version = "1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "sipyco";
    tag = "v${version}";
    hash = "sha256-DkcgZ0K6lsxzBWc31GTyufuSOpcorVv5OsZLHphHBtg=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sipyco" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple Python Communications - used by the ARTIQ experimental control package";
    mainProgram = "sipyco_rpctool";
    homepage = "https://github.com/m-labs/sipyco";
    changelog = "https://github.com/m-labs/sipyco/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ charlesbaynham ];
  };
}
