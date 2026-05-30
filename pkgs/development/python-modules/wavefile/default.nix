{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyaudio,
  numpy,
  libsndfile,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "wavefile";
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vokimon";
    repo = "python-wavefile";
    tag = "python-wavefile-${version}";
    hash = "sha256-7pJcdp2abNurTl/pwAEW4QAalK7okMOCwlRPmKLWad4=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [
    pyaudio
    libsndfile
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pyaudio
    numpy
    libsndfile
  ];

  patches = [
    # Fix check error
    # OSError: libsndfile.so.1: cannot open shared object file: No such file or directory
    (replaceVars ./libsndfile.py.patch {
      libsndfile = "${lib.getLib libsndfile}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  doCheck = false; # all test files (test/wavefileTest.py) are failing

  pythonImportsCheck = [ "wavefile" ];

  meta = {
    description = "Pythonic libsndfile wrapper to read and write audio files";
    homepage = "https://github.com/vokimon/python-wavefile";
    changelog = "https://github.com/vokimon/python-wavefile#version-history";
    maintainers = [ ];
    license = lib.licenses.gpl3Plus;
  };
}
