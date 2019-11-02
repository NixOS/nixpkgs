{ stdenv, fetchFromGitHub, pythonPackages, opencv3 }:

let
  opencv3_ = pythonPackages.toPythonModule (opencv3.override {
    inherit pythonPackages;
    enablePython = true;
    enableFfmpeg = true;
  });
in pythonPackages.buildPythonApplication rec {
  pname = "video2midi";
  version = "0.3.9.5";

  format = "other";

  src = fetchFromGitHub {
    owner = "svsdval";
    repo = pname;
    rev = version;
    sha256 = "1jc50zimc64ilc1as3dyh16lsygwqyvi381mw8si8m9j3pw6may4";
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
