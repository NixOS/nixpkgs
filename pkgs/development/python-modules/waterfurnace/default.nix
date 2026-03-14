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
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdague";
    repo = "waterfurnace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E5GHO4kRfAg+A3FW674i6ekCrpjwYx5rx7xbTZXuT80=";
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
