{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vegehub";
  version = "0.1.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thulrus";
    repo = "VegeHubPyPiLib";
    tag = "V${version}";
    hash = "sha256-OrHUT1WchsaoPNFBZn74jpihd8I/R1RB0+KZRKg9Zrs=";
  };

  postPatch = ''
    rm -r dist
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "vegehub" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/Thulrus/VegeHubPyPiLib/releases/tag/${src.tag}";
    description = "Basic package for simplifying interactions with the Vegetronix VegeHub";
    homepage = "https://github.com/Thulrus/VegeHubPyPiLib";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
