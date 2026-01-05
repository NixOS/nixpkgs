{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "waterfurnace";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdague";
    repo = "waterfurnace";
    tag = "v${version}";
    sha256 = "sha256-lix8dU9PxlsXIzKNFuUJkd80cUYXfTXSnFLu1ULACkE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    requests
    websocket-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "waterfurnace" ];

  meta = {
    description = "Python interface to waterfurnace geothermal systems";
    mainProgram = "waterfurnace";
    homepage = "https://github.com/sdague/waterfurnace";
    changelog = "https://github.com/sdague/waterfurnace/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
