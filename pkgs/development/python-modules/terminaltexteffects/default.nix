{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "terminaltexteffects";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

   # no tests on pypi, no tags on github
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NyWPfdgLeXAxKPJOzB7j4aT+zjrURN59CGcv0Vt99y0=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "terminaltexteffects" ];

  meta = with lib; {
    description = "A collection of visual effects that can be applied to terminal piped stdin text";
    homepage = "https://chrisbuilds.github.io/terminaltexteffects";
    changelog = "https://chrisbuilds.github.io/terminaltexteffects/changeblog/";
    license = licenses.mit;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ qwqawawow ];
    mainProgram = "tte";
  };
}
