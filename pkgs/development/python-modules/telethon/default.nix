{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  openssl,
  rsa,
  pyaes,
  cryptg,
  hatchling,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "telethon";
  version = "1.44.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "Lonami";
    repo = "Telethon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NzLlDwxzLWyySluUazQGPDukT71awCrJZEbjd5T9K/g=";
  };

  postPatch = ''
    substituteInPlace telethon/crypto/libssl.py --replace-fail \
      "ctypes.util.find_library('ssl')" "'${lib.getLib openssl}/lib/libssl.so'"
  '';

  preCheck = ''
    python setup.py gen
  '';

  build-system = [
    hatchling
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
