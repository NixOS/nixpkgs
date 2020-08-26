{ lib, python3 }:

let
  py = python3.override {
    packageOverrides = self: super: {
      loguru = super.loguru.overridePythonAttrs (oldAttrs: rec {
        version = "0.4.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0j47cg3gi8in4z6z4w3by6x02mpkkfl78gr85xjn5rg0nxiz7pfm";
        };
      });
    };
  };

in

with py.pkgs;

buildPythonApplication rec {
  pname = "google-music-scripts";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0apwgj86whrc077dfymvyb4qwj19bawyrx49g4kg364895v0rbbq";
  };

  # pendulum pinning was to prevent PEP517 from trying to build from source
  postPatch = ''
    substituteInPlace setup.py \
      --replace "tomlkit>=0.5,<0.6" "tomlkit" \
      --replace "pendulum>=2.0,<=3.0,!=2.0.5,!=2.1.0" "pendulum"
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
