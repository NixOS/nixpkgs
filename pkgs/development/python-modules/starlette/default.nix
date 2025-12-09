{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  typing-extensions,

  # optional dependencies
  itsdangerous,
  jinja2,
  python-multipart,
  pyyaml,
  httpx,

  # tests
  pytestCheckHook,
  pythonOlder,
  trio,

  # reverse dependencies
  fastapi,
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.47.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "starlette";
    tag = version;
    hash = "sha256-FseSZrLWuNaLro2iLMcfiCrbx2Gz8+aEmLaSk/+PgN4=";
  };

  build-system = [ hatchling ];

  dependencies = [ anyio ] ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  optional-dependencies.full = [
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    httpx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
    typing-extensions
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    "-Wignore::trio.TrioDeprecationWarning"
    "-Wignore::ResourceWarning" # FIXME remove once test suite is fully compatible with anyio 4.4.0
  ];

  pythonImportsCheck = [ "starlette" ];

  passthru.tests = {
    inherit fastapi;
  };

  meta = with lib; {
    changelog = "https://www.starlette.io/release-notes/#${lib.replaceStrings [ "." ] [ "" ] version}";
    downloadPage = "https://github.com/encode/starlette";
    homepage = "https://www.starlette.io/";
    description = "Little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
