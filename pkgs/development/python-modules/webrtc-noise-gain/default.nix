{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  pybind11,
  setuptools,

  # native dependencies
  abseil-cpp,
  darwin,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "webrtc-noise-gain";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "webrtc-noise-gain";
    rev = "v${version}";
    hash = "sha256-ALRdj9zBcx05DcSKjAI0oEPruTD/p+pQ0kcqqyHl37A=";
  };

  nativeBuildInputs = [
    pybind11
    setuptools
  ];

  buildInputs = [
    abseil-cpp
  ] ++ lib.optionals (stdenv.isDarwin) [ darwin.apple_sdk.frameworks.CoreServices ];

  pythonImportsCheck = [ "webrtc_noise_gain" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tiny wrapper around webrtc-audio-processing for noise suppression/auto gain only";
    homepage = "https://github.com/rhasspy/webrtc-noise-gain";
    changelog = "https://github.com/rhasspy/webrtc-noise-gain/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
