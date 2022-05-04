{ lib
, python3
, fetchFromGitHub
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "lexicon";
  version = "3.9.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TySgIxBEl2RolndAkEN4vCIDKaI48vrh2ocd+CTn7Ow=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    boto3
    cryptography
    dnspython
    future
    localzone
    oci
    pynamecheap
    pyyaml
    requests
    softlayer
    tldextract
    transip
    xmltodict
    zeep
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-xdist
    vcrpy
  ];

  disabledTestPaths = [
    # Tests require network access
    "lexicon/tests/providers/test_auto.py"
  ];

  pythonImportsCheck = [
    "lexicon"
  ];

  meta = with lib; {
    description = "Manipulate DNS records of various DNS providers in a standardized way";
    homepage = "https://github.com/AnalogJ/lexicon";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
