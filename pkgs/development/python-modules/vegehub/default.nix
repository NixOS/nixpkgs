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
  version = "0.1.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thulrus";
    repo = "VegeHubPyPiLib";
    tag = "V${version}";
    hash = "sha256-jdD+vYcnrwPVJhVBVvB7ULcD1KrOudUC2K/agxHLnwY=";
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
