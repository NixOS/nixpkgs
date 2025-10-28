{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  procps,
  stdenv,
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvarrazzo";
    repo = "py-setproctitle";
    tag = "version-${version}";
    hash = "sha256-dfOdtfOXRAoCQLW307+YMsFIWRv4CupbKUxckev1oUw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    procps
  ];

  # Setting the process title fails on macOS in the Nix builder environment (regardless of sandboxing)
  disabledTests = if stdenv.hostPlatform.isDarwin then [ "test_setproctitle_darwin" ] else null;

  pythonImportsCheck = [ "setproctitle" ];

  meta = {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage = "https://github.com/dvarrazzo/py-setproctitle";
    changelog = "https://github.com/dvarrazzo/py-setproctitle/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ exi ];
  };
}
