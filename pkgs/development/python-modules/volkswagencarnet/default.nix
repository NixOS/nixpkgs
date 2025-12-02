{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  aiohttp,
  beautifulsoup4,
  lxml,
  pyjwt,
  freezegun,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "volkswagencarnet";
  version = "5.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robinostlund";
    repo = "volkswagencarnet";
    tag = "v${version}";
    hash = "sha256-LH8w+sIInez5hUM/rj1C8ew/RlfKTPKh0ZgLt6cRcnY=";
  };

  postPatch = ''
    substituteInPlace tests/conftest.py \
      --replace-fail 'pytest_plugins = ["pytest_cov"]' 'pytest_plugins = []'
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    beautifulsoup4
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
    changelog = "https://github.com/robinostlund/volkswagencarnet/releases/tag/${src.tag}";
    description = "Python library for volkswagen carnet";
    homepage = "https://github.com/robinostlund/volkswagencarnet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
