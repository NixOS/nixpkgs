{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi

# build-system
, hatchling

# dependencies
, anyio
, typing-extensions

# optional dependencies
, itsdangerous
, jinja2
, python-multipart
, pyyaml
, httpx

# tests
, pytest
, pytestCheckHook
, pythonOlder
, trio

# reverse dependencies
, fastapi
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.37.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "starlette";
    rev = "refs/tags/${version}";
    hash = "sha256-SJdBss1WKC30oulVTYUwUAJ8WM0KF5xbn/gvV97WM2g=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    anyio
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  passthru.optional-dependencies.full = [
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    httpx
  ];

  nativeCheckInputs = [
    (pytestCheckHook.override {
      # pytest 8 changes warning message
      # see https://github.com/encode/starlette/commit/8da52c2243b8855426c40c16ae24b27734824078
      pytest = pytest.overridePythonAttrs (old: rec {
        version = "8.1.0";
        src = fetchPypi {
          pname = "pytest";
          inherit version;
          hash = "sha256-+PoEq4+Y0YUROuYOptecIvgUOxS8HK7O1EoKuESSgyM=";
        };
      });
    })
    trio
    typing-extensions
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
    "-W" "ignore::trio.TrioDeprecationWarning"
  ];

  pythonImportsCheck = [
    "starlette"
  ];

  passthru.tests = {
    inherit fastapi;
  };

  meta = with lib; {
    changelog = "https://www.starlette.io/release-notes/#${lib.replaceStrings [ "." ] [ "" ] version}";
    downloadPage = "https://github.com/encode/starlette";
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
