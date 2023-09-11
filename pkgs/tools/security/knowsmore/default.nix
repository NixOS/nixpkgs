{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knowsmore";
  version = "0.1.37";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "helviojunior";
    repo = "knowsmore";
    rev = "refs/tags/v${version}";
    hash = "sha256-UxBoWK3L4u9xSQaGGHpzvs/mRlmhF3EqiS/4BYyTKos=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aioconsole
    ansi2image
    beautifulsoup4
    clint
    colorama
    impacket
    levenshtein
    minikerberos
    neo4j
    numpy
    pypsrp
    requests
    tabulate
    urllib3
    xmltodict
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "knowsmore"
  ];

  pytestFlagsArray = [
    "tests/tests*"
  ];

  meta = with lib; {
    description = "Tool for pentesting Microsoft Active Directory";
    homepage = "https://github.com/helviojunior/knowsmore";
    changelog = "https://github.com/helviojunior/knowsmore/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
