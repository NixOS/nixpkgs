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
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robinostlund";
    repo = "volkswagencarnet";
    rev = "refs/tags/v${version}";
    hash = "sha256-NpfkhFGxd3VjLjQ8pPpamYgwc5zqWt5CojONe4L1s4s=";
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
    description = "A python library for volkswagen carnet";
    homepage = "https://github.com/robinostlund/volkswagencarnet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
