{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  aiohttp,
  yarl,
  aresponses,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "twentemilieu";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-twentemilieu";
    tag = "v${version}";
    hash = "sha256-N6XSf212orMf3vqIjBzu+4fpKX7kFinH180lCWXtjzc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" "" \
      --replace '"0.0.0"' '"${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "twentemilieu" ];

  meta = with lib; {
    description = "Python client for Twente Milieu";
    homepage = "https://github.com/frenck/python-twentemilieu";
    changelog = "https://github.com/frenck/python-twentemilieu/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
