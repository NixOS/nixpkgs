{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "lexicon";
  version = "3.3.22";

  propagatedBuildInputs = with python3Packages; [ requests tldextract future cryptography pyyaml boto3 zeep xmltodict beautifulsoup4 dnspython pynamecheap softlayer transip localzone ];

  checkInputs = with python3Packages; [ pytest pytestcov pytest_xdist vcrpy mock ];

  checkPhase = ''
    pytest --ignore=lexicon/tests/providers/test_auto.py
  '';

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = pname;
    rev = "v${version}";
    sha256 = "1adwqglh3lrx04y0f6slp1l97xzbsqgw0v5i4jll3a54aqyzfz0a";
  };

  meta = with lib; {
    description = "Manipulate DNS records on various DNS providers in a standardized way.";
    homepage = "https://github.com/AnalogJ/lexicon";
    maintainers = with maintainers; [ flyfloh ];
    license = licenses.mit;
  };
}
