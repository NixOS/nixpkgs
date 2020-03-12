{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "lexicon";
  version = "3.3.17";

  propagatedBuildInputs = with python3Packages; [ requests tldextract future cryptography pyyaml boto3 zeep xmltodict beautifulsoup4 dnspython pynamecheap softlayer transip localzone ];

  checkInputs = with python3Packages; [ pytest pytestcov pytest_xdist vcrpy mock ];

  checkPhase = ''
    pytest --ignore=lexicon/tests/providers/test_auto.py
  '';

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wrsw759am6yp2m9b34iv82m371df3ssp2vhdjr18ys3xk7dvj89";
  };

  meta = with lib; {
    description = "Manipulate DNS records on various DNS providers in a standardized way.";
    homepage = https://github.com/AnalogJ/lexicon;
    maintainers = with maintainers; [ flyfloh ];
    license = licenses.mit;
  };
}
