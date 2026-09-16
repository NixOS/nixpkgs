{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # deps
  isal,
  zlib-ng,

  # tests
  pytestCheckHook,
  pytest-timeout,

  # update
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xopen";
  version = "2.0.2";
  pyproject = true;
  build-system = [
    setuptools
    setuptools-scm
  ];

  src = fetchFromGitHub {
    owner = "pycompression";
    repo = "xopen";
    tag = "v${version}";
    hash = "sha256-E2OggeShagKzRD4Aa7pk90CDD1QBqZvSd+q7xHldI/U=";
  };

  dependencies = [
    isal
    zlib-ng
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
  ];

  pythonImportsCheck = [ "xopen" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open compressed files transparently";
    homepage = "https://github.com/pycompression/xopen";
    downloadPage = "https://github.com/pycompression/xopen/tags";
    changelog = "https://github.com/pycompression/xopen#changelog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
  };
}
