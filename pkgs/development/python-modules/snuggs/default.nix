{ buildPythonPackage, lib, fetchFromGitHub
, click, numpy, pyparsing
, pytest, hypothesis
}:

buildPythonPackage rec {
  pname = "snuggs";
  version = "1.4.7";
  format = "setuptools";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = version;
    sha256 = "1p3lh9s2ylsnrzbs931y2vn7mp2y2xskgqmh767c9l1a33shfgwf";
  };

  propagatedBuildInputs = [ click numpy pyparsing ];

  nativeCheckInputs = [ pytest hypothesis ];
  checkPhase = "pytest test_snuggs.py";

  meta = with lib; {
    description = "S-expressions for Numpy";
    license = licenses.mit;
    homepage = "https://github.com/mapbox/snuggs";
    maintainers = with maintainers; [ mredaelli ];
  };
}
