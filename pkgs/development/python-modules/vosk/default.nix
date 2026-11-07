{ lib
, buildPythonPackage
, fetchPypi
, srt
, requests
, tqdm
, websockets
}:

buildPythonPackage rec {
  pname = "vosk";
  version = "0.3.45";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    dist = "py3";
    platform = "manylinux_2_12_x86_64.manylinux2010_x86_64";

    hash = "sha256-JeAlCTxDmdcnj1Q1aO2MxUYKw6S/SMI2c6zh4l0mYZ8=";
  };

  propagatedBuildInputs = [
    srt
    requests
    tqdm
    websockets
  ];

  meta = with lib; {
    description = "Offline open source speech recognition toolkit";
    mainProgram = "vosk-transcriber";
    homepage = "https://alphacephei.com/vosk/";
    license = licenses.asl20;
  };
}
