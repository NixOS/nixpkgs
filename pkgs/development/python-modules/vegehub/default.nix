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
  version = "0.1.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thulrus";
    repo = "VegeHubPyPiLib";
    tag = "V${version}";
    hash = "sha256-W/5kvertNC7w2IS/N5k06cDyNFgel2s4/znR+Lz5RJU=";
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
    description = "Basic package for simplifying interactions with the Vegetronix VegeHub";
    homepage = "https://github.com/Thulrus/VegeHubPyPiLib";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
