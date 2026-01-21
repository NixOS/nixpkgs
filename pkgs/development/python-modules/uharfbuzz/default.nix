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
  version = "0.53.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-EY5jAzcAHY4lmGsitVFtFMijEfAaSCifCjkdJhU2N1g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 36.4, < 72.2" setuptools
  '';

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
