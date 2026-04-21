{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "wled";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-wled";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CUTuIQf6gj9teLicIOtu1FUsYiYXtKeLNuDbNh/21sc=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${finalAttrs.version}" \
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
    cachetools
    mashumaro
    orjson
    yarl
  ];

  optional-dependencies = {
    cli = [
      typer
      zeroconf
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # wled release table rendering is inconsistent
    "test_releases_command"
  ];

  pythonImportsCheck = [ "wled" ];

  meta = {
    description = "Asynchronous Python client for WLED";
    homepage = "https://github.com/frenck/python-wled";
    changelog = "https://github.com/frenck/python-wled/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
