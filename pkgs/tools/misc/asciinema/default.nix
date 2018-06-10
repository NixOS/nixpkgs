{ lib, python3Packages, fetchFromGitHub }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  name = "asciinema-${version}";
  version = "2.0.0";

  buildInputs = with pythonPackages; [ nose ];
  propagatedBuildInputs = with pythonPackages; [ requests ];

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
    sha256 = "1f92hv9w58jf1f7igspjxvrxqn3n21kgya2zb56spqyydr4jzwdk";
  };

  patchPhase = ''
    # disable one test which is failing with -> OSError: out of pty devices
    rm tests/pty_recorder_test.py
  '';

  checkPhase = ''
    nosetests
  '';

  meta = {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = https://asciinema.org/;
    license = with lib.licenses; [ gpl3 ];
  };
}

