{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,

  # optional dependencies
  itsdangerous,
  jinja2,
  python-multipart,
  pyyaml,
  httpx,
  httpx2,

  # tests
  blockbuster,
  opentelemetry-sdk,
  pytestCheckHook,
  trio,

  # reverse dependencies
  fastapi,
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "starlette";
    tag = version;
    hash = "sha256-9Ti2ktDNfZcG1gVccew06ascsBtUUTGp9ZEJoe0f/aM=";
  };

  build-system = [ hatchling ];

  dependencies = [ anyio ];

  optional-dependencies.full = [
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    httpx
    httpx2
  ];

  nativeCheckInputs = [
    blockbuster
    opentelemetry-sdk
    pytestCheckHook
    trio
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "starlette" ];

  passthru.tests = {
    inherit fastapi;
  };

  meta = {
    changelog = "https://github.com/Kludex/starlette/blob/${src.tag}/docs/release-notes.md";
    downloadPage = "https://github.com/Kludex/starlette";
    homepage = "https://starlette.dev";
    description = "Little ASGI framework that shines";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      booxter
      wd15
    ];
  };
}
