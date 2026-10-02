{
  lib,
  aiohttp,
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  ifaddr,
  lxml,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "soco";
  version = "0.31.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v24UzJ+/TlEBmNYP51UTI96bvi10E5orNFKS5q1bSyE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    ifaddr
    lxml
    requests
    xmltodict
  ];

  optional-dependencies.events_asyncio = [ aiohttp ];

  nativeCheckInputs = [
    graphviz
    mock
    pytest-asyncio
    pytestCheckHook
    requests-mock
  ]
  ++ finalAttrs.passthru.optional-dependencies.events_asyncio;

  pythonImportsCheck = [ "soco" ];

  meta = {
    description = "CLI and library to control Sonos speakers";
    homepage = "http://python-soco.com/";
    changelog = "https://github.com/SoCo/SoCo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
})
