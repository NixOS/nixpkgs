{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cython,
  pkgconfig,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  ApplicationServices,
}:

buildPythonPackage rec {
  pname = "uharfbuzz";
  version = "0.45.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-dfEyeejJdLHGHH+YI0mWdjF2rvFpM6/KVm2tLo9ssUs=";
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

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ ApplicationServices ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "uharfbuzz" ];

  meta = with lib; {
    description = "Streamlined Cython bindings for the harfbuzz shaping engine";
    homepage = "https://github.com/harfbuzz/uharfbuzz";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
