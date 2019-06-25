{ stdenv, fetchFromGitHub, python2Packages, opencv3 }:

let
  opencv3_ = python2Packages.toPythonModule (opencv3.override {
    enablePython = true;
    pythonPackages = python2Packages;
    enableFfmpeg = true;
  });
in stdenv.mkDerivation rec {
  pname = "video2midi";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "svsdval";
    repo = pname;
    rev = version;
    sha256 = "00ms9iqam3ml6fxf8djki3gyifn8sfzfkkfrdgrvs0sq47wrkc39";
  };

  pythonPath = with python2Packages; [ opencv3_ midiutil pygame pyopengl ];
  nativeBuildInputs = with python2Packages; [ python wrapPython ];

  installPhase = ''
    install -Dm755 v2m.py $out/bin/v2m.py
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Youtube synthesia video to midi conversion tool";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
