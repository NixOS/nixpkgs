{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "1.41.1";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "LonamiWebs";
    repo = "Telethon";
    tag = "v${version}";
    hash = "sha256-V38enxg1ZW1zd87xRLr0GHv+t1NK7fwDFxXDqPvCf2U=";
  };

  patches = [
    # https://github.com/LonamiWebs/Telethon/pull/4670
    (fetchpatch {
      url = "https://github.com/LonamiWebs/Telethon/commit/8e2a46568ef9193f5887aea1abf919ac4ca6d31e.patch";
      name = "fix_async_test.patch";
      hash = "sha256-oVpLnO4OxNam/mq945OskVEHkbS5TDSUXk/0xPHVv3I=";
    })
  ]
  ++ lib.optionals (lib.versionOlder version "1.40.1") [
    (fetchpatch {
      url = "https://github.com/LonamiWebs/Telethon/commit/ae9c798e2c3648ff40dee1b3f371f5d66851642e.patch";
      name = "fix_test_messages_test.patch";
      hash = "sha256-8SJm8EE6w7zRQxt1NuTX6KP1MTYPiYO/maJ5tOA2I9w=";
    })
  ];

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
