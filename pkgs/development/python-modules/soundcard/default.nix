{
  buildPythonPackage,
  cffi,
  fetchPypi,
  lib,
  libpulseaudio,
  numpy,
  setuptools,
  testers,
}:
let
  pname = "soundcard";
  version = "0.4.4";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h9+cS47JdYX+RAodnbr6vOzljq5YV+0AXmuzhbIXnP8=";
  };

  patchPhase = ''
    substituteInPlace soundcard/pulseaudio.py \
      --replace "'pulse'" "'${libpulseaudio}/lib/libpulse.so'"
  '';

  build-system = [ setuptools ];

  dependencies = [
    cffi
    numpy
  ];

  # doesn't work because there are not many soundcards in the
  # sandbox. See VM-test
  # pythonImportsCheck = [ "soundcard" ];

  passthru.tests.vm-with-soundcard = testers.runNixOSTest ./test.nix;

  meta = {
    description = "Pure-Python Real-Time Audio Library";
    homepage = "https://github.com/bastibe/SoundCard";
    changelog = "https://github.com/bastibe/SoundCard/blob/${version}/README.rst#changelog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ matthiasdotsh ];
  };
}
