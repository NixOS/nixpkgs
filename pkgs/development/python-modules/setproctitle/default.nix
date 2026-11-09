{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  procps,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "setproctitle";
  version = "1.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvarrazzo";
    repo = "py-setproctitle";
    tag = "version-${finalAttrs.version}";
    hash = "sha256-PGTaK9/Wwd5Lp2tZCVSrnPkfVwWvJIq8rWNQ83OH/eI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    procps
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Setting the process title fails on macOS in the Nix builder environment (regardless of sandboxing)
    "test_setproctitle_darwin"
  ];

  pythonImportsCheck = [ "setproctitle" ];

  meta = {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage = "https://github.com/dvarrazzo/py-setproctitle";
    changelog = "https://github.com/dvarrazzo/py-setproctitle/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ exi ];
  };
})
