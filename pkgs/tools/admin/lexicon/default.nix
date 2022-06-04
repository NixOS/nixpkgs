{ lib
, python3
, fetchFromGitHub
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "lexicon";
  version = "3.11.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z0GaA1O0ctP280QvhdzW7Cxonidz9dOnP6N4RJ+tqfw=";
  };

  postPatch = ''
    substituteInPlace lexicon/tests/providers/test_oci.py \
      --replace "os.remove(KEY_FILE)" 'os.system(f"rm -f {KEY_FILE}")'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    boto3
    cryptography
    dnspython
    importlib-metadata
    localzone
    oci
    pyyaml
    requests
    softlayer
    tldextract
    zeep
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-xdist
    vcrpy
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  disabledTestPaths = [
    # Tests require network access
    "lexicon/tests/providers/test_auto.py"
    # some problem with VCR.py
    "lexicon/tests/providers/test_namecheap.py"
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
