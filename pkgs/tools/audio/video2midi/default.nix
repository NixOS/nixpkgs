{ lib, fetchFromGitHub, pythonPackages, opencv4 }:

let
  opencv4_ = pythonPackages.toPythonModule (opencv4.override {
    inherit pythonPackages;
    enablePython = true;
    enableFfmpeg = true;
  });
in pythonPackages.buildPythonApplication rec {
  pname = "video2midi";
  version = "0.4.6.5";

  format = "other";

  src = fetchFromGitHub {
    owner = "svsdval";
    repo = pname;
    rev = version;
    sha256 = "0qzrxqhsxn0h71nfrsi9g78hx3pqm3b8sr6fjq01k4k6dd2nwfam";
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
