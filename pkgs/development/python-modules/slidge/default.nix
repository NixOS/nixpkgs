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
}:

buildPythonPackage (finalAttrs: {
  pname = "slidge";
  version = "0.3.11";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "slidge";
    repo = "slidge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IUfeNn/zp1iyMSu60VAtJ5A74Q9zTh37B+LFNa6VVLA=";
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

  meta = {
    changelog = "https://codeberg.org/slidge/slidge/releases/tag/v${finalAttrs.version}";
    description = "XMPP/other chat networks gateway library";
    homepage = "https://slidge.im/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ haansn08 ];
  };

})
