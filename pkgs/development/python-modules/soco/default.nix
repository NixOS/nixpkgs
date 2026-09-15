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
  version = "0.31.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TCnKzAOrpQxh8JaBkoPs2e81xUS/iQ8D/Qtt3WU9J1k=";
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
