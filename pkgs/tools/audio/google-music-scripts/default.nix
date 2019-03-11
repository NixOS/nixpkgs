{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "google-music-scripts";
  version = "3.0.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "12risivi11z3shrgs1kpi7x6lvk113cbp3dnczw9mmqhb4mmwviy";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    audio-metadata
    click
    click-default-group
    google-music
    google-music-utils
    logzero
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
