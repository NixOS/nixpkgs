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
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-twentemilieu";
    rev = "refs/tags/v${version}";
    hash = "sha256-R2zCDDSS6vpdD0TGSuYs6Xl8Ij2lU2UWqkOE4aFyxto=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" "" \
      --replace '"0.0.0"' '"${version}"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
