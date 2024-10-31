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
  version = "3.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "stringzilla";
    rev = "refs/tags/v${version}";
    hash = "sha256-E7w6s813OGCld/GRTHMbjVAReTGb37HlB687gP9N9FA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-36LN9AoAWA//pldmQZtKMrck4EoGUW9G2vzdsRw08SA=";
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
