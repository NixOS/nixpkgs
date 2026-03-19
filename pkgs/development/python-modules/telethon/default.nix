{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  pythonAtLeast,
  openssl,
  rsa,
  pyaes,
  cryptg,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "telethon";
  version = "1.42.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "Lonami";
    repo = "Telethon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NMHJkSTGR3/tck0k97EfVN9f85PAWst+EZ6G7Tgrt5s=";
  };

  disabled = pythonAtLeast "3.14";

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
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    homepage = "https://codeberg.org/Lonami/Telethon";
    description = "Full-featured Telegram client library for Python 3";
    license = lib.licenses.mit;
    changelog = "https://codeberg.org/Lonami/Telethon/blob/${finalAttrs.src.tag}/readthedocs/misc/changelog.rst";
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
})
