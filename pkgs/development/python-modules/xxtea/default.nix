{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "xxtea";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ifduyue";
    repo = "xxtea";
    rev = "v${version}";
    hash = "sha256-pGiGvdHaTDPHJcuRU+2axhWpodDGNDGDmZeF0OnzMRg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/test.py" ];

  pythonImportsCheck = [ "xxtea" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XXTEA implemented as a Python extension module";
    homepage = "https://github.com/ifduyue/xxtea";
    changelog = "https://github.com/ifduyue/xxtea/blob/master/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
