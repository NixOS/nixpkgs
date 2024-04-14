{ lib, fetchFromGitHub, pythonPackages, opencv4 }:

let
  opencv4_ = pythonPackages.toPythonModule (opencv4.override {
    inherit pythonPackages;
    enablePython = true;
    enableFfmpeg = true;
  });
in pythonPackages.buildPythonApplication rec {
  pname = "video2midi";
  version = "0.4.7.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "svsdval";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-lM3SBgGUW5MTUtsywy57fBiHEg58a8Fcpqb+EcRaYQ4=";
  };

  propagatedBuildInputs = with pythonPackages; [ opencv4_ midiutil pygame pyopengl ];

  installPhase = ''
    install -Dm755 v2m.py $out/bin/v2m.py
  '';

  meta = with lib; {
    description = "Youtube synthesia video to midi conversion tool";
    homepage = src.meta.homepage;
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "v2m.py";
  };
}
