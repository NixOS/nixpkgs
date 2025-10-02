{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "terminaltexteffects";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # no tests on pypi, no tags on github
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hL+n7vxNA+3jual5TSaiJN80hRU0+ZPfaiN/23RFQu8=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "terminaltexteffects" ];

  meta = with lib; {
    description = "Collection of visual effects that can be applied to terminal piped stdin text";
    homepage = "https://chrisbuilds.github.io/terminaltexteffects";
    changelog = "https://chrisbuilds.github.io/terminaltexteffects/changeblog/";
    license = licenses.mit;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ eihqnh ];
    mainProgram = "tte";
  };
}
