{
  lib,
  buildPythonPackage,
  fetchpatch2,
  fetchPypi,
  pythonOlder,
  importlib-metadata,
  keyring,
  pkginfo,
  readme-renderer,
  requests,
  requests-toolbelt,
  rich,
  rfc3986,
  setuptools-scm,
  urllib3,
  build,
  pretend,
  pytest-socket,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "twine";
  version = "5.1.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mqCCUTnAKzQ02RNUXHuEeiHINeEVl/UlWELUV9ojIts=";
  };

  patches = [
    # pkginfo>=1.11 compatibility patches
    # https://github.com/pypa/twine/pull/1123
    (fetchpatch2 {
      name = "pkginfo-1_11-compatibility-test.patch";
      url = "https://github.com/pypa/twine/commit/a3206073b87a8e939cf699777882ebfaced689a0.patch";
      hash = "sha256-gLN7gJsVng/LFfsrAHjJlqFZTu0wSdeBfnUN+UnLSFk=";
    })
    (fetchpatch2 {
      name = "pkginfo-1_11-compatibility-source.patch";
      url = "https://github.com/pypa/twine/commit/03e3795659b44f263f527b0467680b238c8fbacc.patch";
      hash = "sha256-Ne9+G8hMVbklKtcZLiBw29Skz5VO5x2F7yu/KozKgN8=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  pythonRelaxDeps = [ "pkginfo" ];

  propagatedBuildInputs = [
    importlib-metadata
    keyring
    pkginfo
    readme-renderer
    requests
    requests-toolbelt
    rfc3986
    rich
    urllib3
  ];

  nativeCheckInputs = [
    build
    pretend
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "twine" ];

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    mainProgram = "twine";
    homepage = "https://github.com/pypa/twine";
    license = lib.licenses.asl20;
  };
}
