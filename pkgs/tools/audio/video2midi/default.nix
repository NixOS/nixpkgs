{ stdenv, fetchFromGitHub, pythonPackages, opencv3 }:

let
  opencv3_ = pythonPackages.toPythonModule (opencv3.override {
    inherit pythonPackages;
    enablePython = true;
    enableFfmpeg = true;
  });
in pythonPackages.buildPythonApplication rec {
  pname = "video2midi";
  version = "0.3.9.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "svsdval";
    repo = pname;
    rev = version;
    sha256 = "1ndzhfng8z5080n1xkcavw21dm6rjz0x1954v9llifsdmf4cpn8y";
  };

  propagatedBuildInputs = with pythonPackages; [ opencv3_ midiutil pygame pyopengl ];

  installPhase = ''
    install -Dm755 v2m.py $out/bin/v2m.py
  '';

  meta = with stdenv.lib; {
    description = "Youtube synthesia video to midi conversion tool";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
