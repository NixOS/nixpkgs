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

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "webrtc-noise-gain";
  version = "1.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "webrtc-noise-gain";
    tag = "v${version}";
    hash = "sha256-GbdG2XM11zgPk2VZ0mu7qMv256jaMyJDHdBCBUnynMY=";
  };

  postPatch = with stdenv.hostPlatform.uname; ''
    # Configure the correct host platform for cross builds
    substituteInPlace setup.py --replace-fail \
      "system = platform.system().lower()" \
      'system = "${lib.toLower system}"'
    substituteInPlace setup.py --replace-fail \
      "machine = platform.machine().lower()" \
      'machine = "${lib.toLower processor}"'
  '';

  nativeBuildInputs = [
    pybind11
    setuptools
  ];

  buildInputs = [ abseil-cpp ];

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
