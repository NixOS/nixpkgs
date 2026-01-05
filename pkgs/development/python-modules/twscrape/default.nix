{
  lib,
  aiosqlite,
  beautifulsoup4,
  buildPythonPackage,
  fake-useragent,
  fetchFromGitHub,
  hatchling,
  httpx,
  loguru,
  pyotp,
  pytestCheckHook,
  pytest-asyncio,
  pytest-httpx,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "twscrape";
  version = "0.17.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "twscrape";
    tag = "v${version}";
    hash = "sha256-0j6nE8V0CWTuIHMS+2p5Ncz7d+D6VagjtyfMbQuI8Eg=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "beautifulsoup4" ];

  dependencies = [
    aiosqlite
    beautifulsoup4
    fake-useragent
    httpx
    loguru
    pyotp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpx
  ];

  pythonImportsCheck = [ "twscrape" ];

  meta = {
    description = "Twitter API scrapper with authorization support";
    homepage = "https://github.com/vladkens/twscrape";
    changelog = "https://github.com/vladkens/twscrape/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
