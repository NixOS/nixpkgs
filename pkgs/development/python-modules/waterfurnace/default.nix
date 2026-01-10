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

buildPythonPackage (finalAttrs: {
  pname = "waterfurnace";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdague";
    repo = "waterfurnace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mg2Kuw54Lc4vZCSAM8FE6l00XBBqLVZEkaoGrP+Fcyo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    requests
    websocket-client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "waterfurnace" ];

  meta = {
    description = "Python interface to waterfurnace geothermal systems";
    homepage = "https://github.com/sdague/waterfurnace";
    changelog = "https://github.com/sdague/waterfurnace/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "waterfurnace";
  };
})
