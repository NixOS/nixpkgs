{ lib, fetchFromGitHub, pythonPackages, opencv3 }:

let
  opencv3_ = pythonPackages.toPythonModule (opencv3.override {
    inherit pythonPackages;
    enablePython = true;
    enableFfmpeg = true;
  });
in pythonPackages.buildPythonApplication rec {
  pname = "video2midi";
  version = "0.4.0.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "svsdval";
    repo = pname;
    rev = version;
    sha256 = "174ijn8bc306529scd23szvgx1apanm2qmwk4lwmi64rhkm6dapx";
  };

  propagatedBuildInputs = with pythonPackages; [ opencv3_ midiutil pygame pyopengl ];

  installPhase = ''
    install -Dm755 v2m.py $out/bin/v2m.py
  '';

  meta = with lib; {
    description = "Youtube synthesia video to midi conversion tool";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
