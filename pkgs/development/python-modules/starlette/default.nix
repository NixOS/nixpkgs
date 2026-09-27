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
  pytestCheckHook,
  trio,

  # reverse dependencies
  fastapi,
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "starlette";
    tag = version;
    hash = "sha256-Cp6wkRxbDdC+Yf3z4TvRF5xrchJ+PAo36qHbBg+FcXw=";
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
