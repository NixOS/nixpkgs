{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lgpio,
}:

buildPythonPackage (finalAttrs: {
  pname = "rpi-lgpio";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "waveform80";
    repo = "rpi-lgpio";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-Fmj03O4nWsu02uXhT67KyIN/OvDSiJrx91HhgyldJmk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lgpio
  ];

  # Tests do a platform check which requires running on a Raspberry Pi
  doCheck = false;

  meta = {
    description = "Python module to control the GPIO on a Raspberry Pi";
    homepage = "https://github.com/waveform80/rpi-lgpio";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      robertjakub
    ];
  };
})
