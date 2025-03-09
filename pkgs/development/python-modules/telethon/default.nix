{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  rsa,
  pyaes,
  cryptg,
  pythonOlder,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.37.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "LonamiWebs";
    repo = "Telethon";
    rev = "refs/tags/v${version}";
    hash = "sha256-P7FP+Wqi3dqbBCFpI9aCDvK4k3mWv8076RO6MXg+jFQ=";
  };

  patchPhase = ''
    substituteInPlace telethon/crypto/libssl.py --replace-fail \
      "ctypes.util.find_library('ssl')" "'${lib.getLib openssl}/lib/libssl.so'"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    pyaes
    rsa
  ];

  optional-dependencies = {
    cryptg = [ cryptg ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/LonamiWebs/Telethon/issues/4254
    "test_all_methods_present"
    "test_private_get_extension"
  ];

  meta = {
    homepage = "https://github.com/LonamiWebs/Telethon";
    description = "Full-featured Telegram client library for Python 3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
