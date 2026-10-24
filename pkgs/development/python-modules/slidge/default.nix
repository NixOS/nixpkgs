{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  aiohttp,
  alembic,
  configargparse,
  defusedxml,
  pillow,
  python-magic,
  qrcode,
  slixmpp,
  sqlalchemy,
  thumbhash,

  # check dependencies
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "slidge";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "slidge";
    repo = "slidge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VdK6GE3P9iZabR/qjaqkaq3VNRtDn0O7ty2NIHMOmBE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    alembic
    configargparse
    defusedxml
    pillow
    python-magic
    qrcode
    slixmpp
    sqlalchemy
    thumbhash
  ];

  pythonRelaxDeps = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTestPaths = [
    # Using slixmpp.test.ComponentXMPP which was removed in latest slixmpp
    "tests/test_adhoc/test_confirmation.py"
    "tests/test_chat_commands.py"
  ];

  disabledTests = [
    "test_vcard_temp"
  ];

  meta = {
    changelog = "https://codeberg.org/slidge/slidge/releases/tag/${finalAttrs.src.tag}";
    description = "Gateway Library for XMPP to Other Networks";
    homepage = "https://slidge.im/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ haansn08 ];
  };

})
