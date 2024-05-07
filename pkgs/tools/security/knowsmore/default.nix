{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knowsmore";
  version = "0.1.38";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "helviojunior";
    repo = "knowsmore";
    rev = "refs/tags/v${version}";
    hash = "sha256-A68JuzlWvq3OAtgq6uAFcTTYKmL7xjKWZ0HQfVXKt4k=";
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
    mainProgram = "knowsmore";
    homepage = "https://github.com/helviojunior/knowsmore";
    changelog = "https://github.com/helviojunior/knowsmore/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
