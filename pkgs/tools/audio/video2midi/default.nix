{ stdenv, fetchFromGitHub, pythonPackages, opencv3 }:

let
  opencv3_ = pythonPackages.toPythonModule (opencv3.override {
    inherit pythonPackages;
    enablePython = true;
    enableFfmpeg = true;
  });
in pythonPackages.buildPythonApplication rec {
  pname = "video2midi";
  version = "0.4.0.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "svsdval";
    repo = pname;
    rev = version;
    sha256 = "1869w60kprjdikqk4iwx058zri2jg4aznzlg668w9myka4mp01r9";
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
