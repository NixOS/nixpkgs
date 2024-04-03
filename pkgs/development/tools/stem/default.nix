{ lib
, fetchurl
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "stem";
  version = "1.8.2";

  src = fetchurl {
    url = "https://gitlab.torproject.org/tpo/network-health/stem/-/archive/1.8.2/stem-1.8.2.tar.gz";
    hash = "sha256-RuHyrFZLDdjw2IwQjX9F5cFqQ2vYuG0W/tlcMnskd1k=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools ];

  doCheck = false;

  meta = with lib; {
    description = "Stem is a Python controller library for Tor";
    homepage = "https://stem.torproject.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "tor-prompt";
  };
}
