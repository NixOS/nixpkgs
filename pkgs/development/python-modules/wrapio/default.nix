{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wrapio";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CUocIbdZ/tJQCxAHzhFpB267ynlXf8Mu+thcRRc0yeg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "wrapio" ];

  meta = {
    description = "Handling event-based streams";
    homepage = "https://github.com/Exahilosys/wrapio";
    changelog = "https://github.com/Exahilosys/wrapio/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sfrijters ];
  };
}
