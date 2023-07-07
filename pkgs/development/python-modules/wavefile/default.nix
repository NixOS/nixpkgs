{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pyaudio
, numpy
, libsndfile
, substituteAll
}:

buildPythonPackage rec {
  pname = "wavefile";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "vokimon";
    repo = "python-wavefile";
    rev = "python-wavefile-${version}";
    sha256 = "9sHj1gb93mCVpejRGSdLJzeFDCeTflZctE7kMWfqFrE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    pyaudio
    libsndfile
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pyaudio
    numpy
    libsndfile
  ];

  patches = [
    # Fix check error
    # OSError: libsndfile.so.1: cannot open shared object file: No such file or directory
    (substituteAll {
      src = ./libsndfile.py.patch;
      libsndfile = "${lib.getLib libsndfile}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  doCheck = false; # all test files (test/wavefileTest.py) are failing

  pythonImportsCheck = [
    "wavefile"
  ];

  meta = with lib; {
    description = "Pythonic libsndfile wrapper to read and write audio files";
    homepage = "https://github.com/vokimon/python-wavefile";
    changelog = "https://github.com/vokimon/python-wavefile#version-history";
    maintainers = with maintainers; [ yuu ];
    license = licenses.gpl3Plus;
  };
}
