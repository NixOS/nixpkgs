{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  unittestCheckHook,

  # important downstream dependencies
  flit,
  black,
  mypy,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "tomli";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = "tomli";
    tag = finalAttrs.version;
    hash = "sha256-MBcmp0SeK/wum3c2c/eu8VEofXDguolHI30QwKahAGE=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "tomli" ];

  passthru.tests = {
    # test downstream dependencies
    inherit
      flit
      black
      mypy
      setuptools-scm
      ;
  };

  __structuredAttrs = true;

  meta = {
    description = "Python library for parsing TOML, fully compatible with TOML v1.0.0";
    homepage = "https://github.com/hukkin/tomli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
})
