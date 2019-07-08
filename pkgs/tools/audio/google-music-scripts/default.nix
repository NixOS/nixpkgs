{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "google-music-scripts";
  version = "4.0.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "5b2e9fdde8781a6d226984f0b61add2415a3804123ceeecb20fcc8527de9389d";
  };

  patches = [ ./loguru.patch ];

  propagatedBuildInputs = with python3.pkgs; [
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
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music-scripts;
    description = "A CLI utility for interacting with Google Music";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
