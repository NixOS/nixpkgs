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
  version = "1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "sipyco";
    rev = "refs/tags/v${version}";
    hash = "sha256-PPnAyDedUQ7Og/Cby9x5OT9wMkNGTP8GS53V6N/dk4w=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sipyco" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Simple Python Communications - used by the ARTIQ experimental control package";
    mainProgram = "sipyco_rpctool";
    homepage = "https://github.com/m-labs/sipyco";
    changelog = "https://github.com/m-labs/sipyco/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ charlesbaynham ];
  };
}
