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
  version = "5.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robinostlund";
    repo = "volkswagencarnet";
    tag = "v${version}";
    hash = "sha256-e1QfD5/zB2iEmp7iTTZi8+beDSlC6xXjGRLxb9m65sA=";
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
