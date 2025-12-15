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
  version = "0.4.5";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BycrqSfjLK/fY05KHKU7mjIYMhpgx9Lgj1S4MqVpRqo=";
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
