{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  python-backoff,
  syrupy,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "wled";
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-wled";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1JLW3wze4W3Uva9xIeSAmYw8f9tDfGxe9rueixVedms=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${finalAttrs.version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    mashumaro
    orjson
    python-backoff
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
    # outdated snapshots
    "test_device_version_fixture"
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
