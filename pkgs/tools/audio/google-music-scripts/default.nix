{ lib, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "google-music-scripts";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dykjhqklbpqr1lvls0bgf6xkwvslj37lx4q8522hjbs150pwjmq";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "audio-metadata>=0.8,<0.9" "audio-metadata"
  '';

  propagatedBuildInputs = [
    appdirs
    audio-metadata
    google-music
    google-music-proto
    google-music-utils
    loguru
    pendulum
    natsort
    tomlkit
  ];

  # No tests
  checkPhase = ''
    $out/bin/gms --help >/dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/thebigmunch/google-music-scripts";
    description = "A CLI utility for interacting with Google Music";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
