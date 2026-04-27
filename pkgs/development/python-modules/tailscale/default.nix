{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
  syrupy,
  typer,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "tailscale";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-tailscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lvtx3/tYJO8qCQhVjJTV0qu064duH7MI+A+a+pdeoHI=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  optional-dependencies = {
    cli = [
      rich
      typer
    ];
  };

  nativeCheckInputs = [
    aioresponses
    click
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "tailscale" ];

  meta = {
    description = "Python client for the Tailscale API";
    homepage = "https://github.com/frenck/python-tailscale";
    changelog = "https://github.com/frenck/python-tailscale/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tailscale";
  };
})
