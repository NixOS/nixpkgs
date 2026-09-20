{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  pkgconfig,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uharfbuzz";
  version = "0.56.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-pxfLUOx4oeymrOb4KnRjEIu4CXp0HKUbWeUT9144k8Q";
  };

  build-system = [
    cython
    pkgconfig
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "uharfbuzz" ];

  meta = {
    description = "Streamlined Cython bindings for the harfbuzz shaping engine";
    homepage = "https://github.com/harfbuzz/uharfbuzz";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
