{ lib
, python3
, fetchFromGitHub
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "lexicon";
  version = "3.11.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TySgIxBEl2RolndAkEN4vCIDKaI48vrh2ocd+CTn7Ow=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    cryptography
    importlib-metadata
    pyyaml
    requests
    tldextract
  ];

  passthru.optional-dependencies = {
    route53 = [
      boto3
    ];
    localzone = [
      localzone
    ];
    softlayer = [
      softlayer
    ];
    gransy = [
      zeep
    ];
    ddns = [
      dnspython
    ];
    oci = [
      oci
    ];
    full = [
      boto3
      dnspython
      localzone
      oci
      softlayer
      zeep
    ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-xdist
    vcrpy
  ] ++ passthru.optional-dependencies.full;

  disabledTestPaths = [
    # Tests require network access
    "lexicon/tests/providers/test_auto.py"
    # Tests require an additional setup
    "lexicon/tests/providers/test_localzone.py"
  ];

  pythonImportsCheck = [
    "lexicon"
  ];

  meta = with lib; {
    description = "Manipulate DNS records of various DNS providers in a standardized way";
    homepage = "https://github.com/AnalogJ/lexicon";
    changelog = "https://github.com/AnalogJ/lexicon/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
