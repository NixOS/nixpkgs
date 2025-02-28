{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  numpy,
  pytest-repeat,
  pytestCheckHook,
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  pname = "stringzilla";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "stringzilla";
    tag = "v${version}";
    hash = "sha256-8RM850pd8gEgmbYg+jczAxkivumAV5PeCcruya+4sCs=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # error: unsupported option '-mfloat-abi=' for target 'aarch64-apple-darwin'
    substituteInPlace setup.py \
      --replace-fail '"-mfloat-abi=hard",' ""
  '';

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "stringzilla" ];

  nativeCheckInputs = [
    numpy
    pytest-repeat
    pytestCheckHook
  ];

  pytestFlagsArray = [ "scripts/test.py" ];

  meta = {
    changelog = "https://github.com/ashvardanian/StringZilla/releases/tag/${src.tag}";
    description = "SIMD-accelerated string search, sort, hashes, fingerprints, & edit distances";
    homepage = "https://github.com/ashvardanian/stringzilla";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
