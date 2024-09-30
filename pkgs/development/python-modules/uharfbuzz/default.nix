{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cython,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  ApplicationServices,
}:

buildPythonPackage rec {
  pname = "uharfbuzz";
  version = "0.39.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-I4fCaomq26FdkpiJdj+zyrbdqdynnD2hIutYTuTFvQs=";
  };

  nativeBuildInputs = [
    cython
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
