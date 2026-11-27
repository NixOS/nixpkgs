{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pythonOlder,
  hatchling,
  uv-dynamic-versioning,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "theben-conexa-smgw";
  version = "0.4.4";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitLab {
    owner = "michael.dluhosch";
    repo = "theben-conexa-smgw";
    tag = finalAttrs.version;
    hash = "sha256-tYi5ZDSy52+0UCT49ATeTknxDDsNFf6aqwiwpMJUI7U=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [ aiohttp ];

  # Upstream does not provide tests.
  doCheck = false;

  pythonImportsCheck = [ "theben_conexa_smgw" ];

  meta = {
    description = "API for Theben Conexa 3.0 Smart Meter Gateway";
    homepage = "https://gitlab.com/michael.dluhosch/theben-conexa-smgw";
    changelog = "https://gitlab.com/michael.dluhosch/theben-conexa-smgw/-/tags/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
