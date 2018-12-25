{ buildPythonPackage, lib, fetchFromGitHub
, click, numpy, pyparsing
, pytest
}:

buildPythonPackage rec {
  pname = "snuggs";
  version = "1.4.2";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = version;
    sha256 = "1q6jqwai4qgghdjgwhyx3yz8mlrm7p1vvnwc339lfl028hrgb5kb";
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
