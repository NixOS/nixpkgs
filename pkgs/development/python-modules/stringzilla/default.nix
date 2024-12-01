{
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  lib,
  numpy,
  pytest-repeat,
  pytestCheckHook,
  rustPlatform,
  rustc,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stringzilla";
  version = "3.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "stringzilla";
    rev = "refs/tags/v${version}";
    hash = "sha256-36W7/PL8nRty8cHuMoTr73tQ4uvtjkwP9lyzNLCuhv0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-qa03Jd0MMtDwkp2E81MacRMbzD/O7E29BT0tc2OjLiY=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  pythonImportsCheck = [ "stringzilla" ];

  nativeCheckInputs = [
    numpy
    pytest-repeat
    pytestCheckHook
  ];

  pytestFlagsArray = [ "scripts/test.py" ];

  meta = {
    changelog = "https://github.com/ashvardanian/StringZilla/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "SIMD-accelerated string search, sort, hashes, fingerprints, & edit distances";
    homepage = "https://github.com/ashvardanian/stringzilla";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
