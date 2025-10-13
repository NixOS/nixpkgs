{
  lib,
  fetchFromGithub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "timelength";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EtorixDev";
    repo = "timelength";
    tag = "v${version}";
  };

  build-system = [
    setuptools
    poetry-core
  ];

  pythonImportsCheck = [ "timelength" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Flexible python duration parser designed for human readable lengths of time";
    homepage = "https://github.com/EtorixDev/timelength/";
    changelog = "https://github.com/EtorixDev/timelength/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Vinetos ];
  };
}
