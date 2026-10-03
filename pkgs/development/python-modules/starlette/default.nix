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
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "starlette";
    tag = version;
    hash = "sha256-5/gQtC0JbQM7eSQeu2aVJtD63v4LjnbSSC0jF96e958=";
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
    homepage = "https://www.starlette.io/";
    description = "Little ASGI framework that shines";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wd15 ];
  };
}
