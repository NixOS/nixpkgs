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
}:

buildPythonPackage (finalAttrs: {
  pname = "twscrape";
  version = "0.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "twscrape";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FQYBC/b2L+c6UtqMZcsuVom01n0sRpBvMTnE2zZh86U=";
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
    changelog = "https://github.com/vladkens/twscrape/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
})
