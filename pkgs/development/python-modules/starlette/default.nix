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
<<<<<<< HEAD
  version = "0.50.0";
  pyproject = true;

=======
  version = "0.47.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "encode";
    repo = "starlette";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-8REOizYQQkyLZwV4/yRiNGmGV07V0NNky7gtiAdWa7o=";
=======
    hash = "sha256-FseSZrLWuNaLro2iLMcfiCrbx2Gz8+aEmLaSk/+PgN4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    "-Wignore::trio.TrioDeprecationWarning"
    "-Wignore::ResourceWarning" # FIXME remove once test suite is fully compatible with anyio 4.4.0
  ];

  pythonImportsCheck = [ "starlette" ];

  passthru.tests = {
    inherit fastapi;
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://www.starlette.io/release-notes/#${lib.replaceStrings [ "." ] [ "" ] version}";
    downloadPage = "https://github.com/encode/starlette";
    homepage = "https://www.starlette.io/";
    description = "Little ASGI framework that shines";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wd15 ];
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
