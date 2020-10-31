{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "lexicon";
  version = "3.4.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hwxx93c68k3gn6bpbb8jl443bcc14pk9ndx8wkyaykyk9ham49k";
  };

  nativeBuildInputs = with python3Packages; [
    poetry
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    boto3
    cryptography
    dnspython
    future
    localzone
    pynamecheap
    pyyaml
    requests
    softlayer
    tldextract
    transip
    xmltodict
    zeep
  ];

  checkInputs = with python3Packages; [
    mock
    pytest
    pytestcov
    pytest_xdist
    vcrpy
  ];

  checkPhase = ''
    pytest --ignore=lexicon/tests/providers/test_auto.py
  '';

  meta = with lib; {
    description = "Manipulate DNS records on various DNS providers in a standardized way";
    homepage = "https://github.com/AnalogJ/lexicon";
    maintainers = with maintainers; [ flyfloh ];
    license = licenses.mit;
  };
}
