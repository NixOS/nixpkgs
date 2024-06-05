{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  numpy,
  testers,
  libpulseaudio,
}:

buildPythonPackage rec {
  pname = "soundcard";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bastibe";
    repo = "soundcard";
    rev = version;
    hash = "sha256-d91fhgkjnRFamMIn7hmXuHZt6kGBysAhQq8IsZ/WqHs=";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace soundcard/pulseaudio.py \
      --replace-fail "dlopen('pulse')" "dlopen('${libpulseaudio}/lib/libpulse.so')"
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

  meta = with lib; {
    description = "A Pure-Python Real-Time Audio Library";
    homepage = "https://github.com/bastibe/SoundCard";
    changelog = "https://soundcard.readthedocs.io/en/latest/#changelog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}
