{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  rsa,
  pyaes,
  cryptg,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "telethon";
  version = "1.42.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LonamiWebs";
    repo = "Telethon";
    tag = "v${version}";
    hash = "sha256-NMHJkSTGR3/tck0k97EfVN9f85PAWst+EZ6G7Tgrt5s=";
  };

  postPatch = ''
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

  meta = {
    homepage = "https://github.com/LonamiWebs/Telethon";
    description = "Full-featured Telegram client library for Python 3";
    license = lib.licenses.mit;
    changelog = "https://github.com/LonamiWebs/Telethon/blob/${src.tag}/readthedocs/misc/changelog.rst";
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
