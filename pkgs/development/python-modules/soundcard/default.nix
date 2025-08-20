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
  version = "0.4.3";
in
buildPythonPackage {
  inherit version;
  pname = "soundcard";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "SoundCard";
    hash = "sha256-QQg1UUuhCAmAPLmIfUJw85K1nq82WRW7lFFq8/ix0Dc=";
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
