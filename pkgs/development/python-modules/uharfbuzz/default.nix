{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cython,
  pkgconfig,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uharfbuzz";
  version = "0.51.1";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-mVxG0unTjMjb0/6w58Py+TARw8YmOWljTlQQwUEdMpg=";
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

  meta = with lib; {
    description = "Streamlined Cython bindings for the harfbuzz shaping engine";
    homepage = "https://github.com/harfbuzz/uharfbuzz";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
