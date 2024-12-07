{ lib, fetchFromGitHub, pythonPackages, opencv4 }:

let
  opencv4_ = pythonPackages.toPythonModule (opencv4.override {
    inherit pythonPackages;
    enablePython = true;
    enableFfmpeg = true;
  });
in pythonPackages.buildPythonApplication rec {
  pname = "video2midi";
  version = "0.4.9";

  format = "other";

  src = fetchFromGitHub {
    owner = "svsdval";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-mjqlNUCEiP5dQS0a8HAejOJyEvY6jGFJFpVcnzU2Vds=";
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
