{ buildPythonPackage, lib, fetchFromGitHub
, click, numpy, pyparsing
, pytest
}:

buildPythonPackage rec {
  pname = "snuggs";
  version = "1.4.3";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = version;
    sha256 = "198nbgkhlg4ik2i1r2cp900iqlairh2hnii2y8v5wy1qk3rv0s9g";
  };

  propagatedBuildInputs = [ click numpy pyparsing ];

  checkInputs = [ pytest ];
  checkPhase = "pytest test_snuggs.py";

  meta = with lib; {
    description = "S-expressions for Numpy";
    license = licenses.mit;
    homepage = https://github.com/mapbox/snuggs;
    maintainers = with maintainers; [ mredaelli ];
  };
}
