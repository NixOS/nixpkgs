{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  click,
  fetchFromGitHub,
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
  pname = "twentemilieu";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-twentemilieu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSUKluCE66oA0QbPlJ3niIuewvBxPmj18ZCUBNCFr4o=";
  };

  postPatch = ''
    # Upstream is creating GitHub releases without version
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${finalAttrs.version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
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

  pythonImportsCheck = [ "twentemilieu" ];

  disabledTests = [
    # Upstream issue with CLI structure test
    "test_cli_structure"
  ];

  meta = {
    description = "Python client for Twente Milieu";
    homepage = "https://github.com/frenck/python-twentemilieu";
    changelog = "https://github.com/frenck/python-twentemilieu/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
