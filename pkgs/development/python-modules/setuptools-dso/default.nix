{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  nose2,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "setuptools-dso";
  version = "2.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "epics-base";
    repo = "setuptools_dso";
    tag = version;
    hash = "sha256-YYm3mTA443vcD/4vHa7EgPzvDDzBic64NWWJDQYQHKs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    nose2
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # distutils.compilers.C.errors.CompileError: command '/nix/store/...-clang-wrapper-21.1.2/bin/clang' failed with exit code 1
    # fatal error: 'string' file not found
    "test_cxx"
  ];

  meta = {
    description = "Setuptools extension for building non-Python Dynamic Shared Objects";
    homepage = "https://github.com/mdavidsaver/setuptools_dso";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
