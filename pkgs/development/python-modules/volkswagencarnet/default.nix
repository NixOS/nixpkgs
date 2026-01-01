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
<<<<<<< HEAD
  version = "5.3.3";
=======
  version = "5.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robinostlund";
    repo = "volkswagencarnet";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-p2J5CCZ0mMXZl4vV6bVJBspPq9I/3u60R6wOd7jg1iY=";
=======
    hash = "sha256-dhLYuGP0m+4eSqJS43AXDhTsberZ4XMuUusmdrgtr4E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
