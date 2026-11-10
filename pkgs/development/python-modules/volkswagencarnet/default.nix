{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  aiohttp,
  beautifulsoup4,
  json5,
  lxml,
  pyjwt,
  freezegun,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "volkswagencarnet";
  version = "5.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robinostlund";
    repo = "volkswagencarnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0jjshQOqrqks0M3b6wXcF50iHZG7RmWSWvUt/Vsjtp8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.0.0" setuptools \
      --replace-fail "setuptools_scm>=10.2.1" setuptools_scm \
      --replace-fail "wheel>=0.48.0" wheel

    substituteInPlace tests/conftest.py \
      --replace-fail 'pytest_plugins = ["pytest_cov"]' 'pytest_plugins = []'
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    beautifulsoup4
    json5
    lxml
    pyjwt
  ];

  pythonImportsCheck = [ "volkswagencarnet" ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/robinostlund/volkswagencarnet/releases/tag/${finalAttrs.src.tag}";
    description = "Python library for volkswagen carnet";
    homepage = "https://github.com/robinostlund/volkswagencarnet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
