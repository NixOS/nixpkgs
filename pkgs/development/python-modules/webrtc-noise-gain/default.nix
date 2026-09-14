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

buildPythonPackage (finalAttrs: {
  pname = "webrtc-noise-gain";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "webrtc-noise-gain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EfMqmtdW7k7DDPWxpOOsnpH9H4ifGQORnNlO+pnoLRk=";
  };

  patches = [
    ./0001-fix-missing-cstdint-include.patch
  ];

  postPatch = with stdenv.hostPlatform.uname; ''
    # Configure the correct host platform for cross builds
    substituteInPlace setup.py --replace-fail \
      "system = platform.system().lower()" \
      'system = "${lib.toLower system}"'
    substituteInPlace setup.py --replace-fail \
      "machine = platform.machine().lower()" \
      'machine = "${lib.toLower processor}"'
  '';

  build-system = [ setuptools ];

  buildInputs = [ abseil-cpp ];

  pythonImportsCheck = [ "webrtc_noise_gain" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf webrtc_noise_gain
  '';

  meta = {
    description = "Tiny wrapper around webrtc-audio-processing for noise suppression/auto gain only";
    homepage = "https://github.com/rhasspy/webrtc-noise-gain";
    changelog = "https://github.com/rhasspy/webrtc-noise-gain/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
