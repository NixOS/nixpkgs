{ lib, buildPythonApplication, fetchFromGitHub, vosk, nixosTests }:

buildPythonApplication rec {
  pname = "vosk-server";
  version = "unstable-2022-04-01";

  src = fetchFromGitHub {
    owner = "alphacep";
    repo = pname;
    rev = "1ef2052573fb75a0ebca3458279a89c613383d99";
    sha256 = "sha256-0hHHJLQfCWetfB+ab6O6B700sTjs9nsLeldcTWUfvrY=";
  };

  sourceRoot = "source/websocket";

  format = "custom";

  propagatedBuildInputs = [ vosk ];

  installPhase = ''
    runHook preInstall
    install -D asr_server.py $out/bin/vosk-server
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) vosk;
  };

  meta = with lib; {
    homepage = "https://alphacephei.com/vosk/server";
    description = "Server for highly accurate offline speech recognition using Kaldi and Vosk";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
  };
}
