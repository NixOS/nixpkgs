{ lib, buildPythonPackage, vosk, cffi, requests, srt, tqdm, websockets }:

buildPythonPackage rec {
  pname = "vosk";
  inherit (vosk) version src meta;

  sourceRoot = "source/python";

  postPatch = ''
    substituteInPlace vosk/__init__.py \
      --replace "dlldir = os.path.abspath(os.path.dirname(__file__))" 'dlldir = "${vosk}/lib"'
  '';

  propagatedBuildInputs = [
    cffi
    requests
    srt
    tqdm
    websockets
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "vosk" ];
}
