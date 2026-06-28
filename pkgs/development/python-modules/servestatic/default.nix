{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  packaging,

  # dependencies
  asgiref,
  django,

  # optional-dependencies
  brotli,
  rcssmin,
  rjsmin,

  # tests
  httpx,
  pytest-sugar,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "servestatic";
  version = "4.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Archmonger";
    repo = "ServeStatic";
    tag = finalAttrs.version;
    hash = "sha256-lMiKZo6dS6fiCQBz/7PPkeEUOutPn0+8cclUikmWWTY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "packaging<26" "packaging"
  '';

  build-system = [
    hatchling
    packaging
  ];

  dependencies = [
    asgiref
    django
  ];

  optional-dependencies = {
    brotli = [
      brotli
    ];
    minify = [
      rcssmin
      rjsmin
    ];
  };

  pythonRelaxDeps = [
    "packaging"
  ];

  pythonImportsCheck = [
    "servestatic"
  ];

  nativeCheckInputs = [
    httpx
    pytest-sugar
    pytest-timeout
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.brotli
  ++ finalAttrs.passthru.optional-dependencies.minify;

  disabledTests = [
    # AssertionError
    "test_modified"
  ];

  meta = {
    description = "Production-grade Python static file server";
    homepage = "https://github.com/Archmonger/ServeStatic";
    changelog = "https://github.com/Archmonger/ServeStatic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
