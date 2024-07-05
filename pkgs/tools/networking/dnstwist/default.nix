{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnstwist";
  version = "20240116";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elceef";
    repo = "dnstwist";
    rev = "refs/tags/${version}";
    hash = "sha256-areFRDi728SedArhUy/rbPzhoFabNoT/WdyyN+6OQK0=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
    geoip
    ppdeep
    requests
    tld
    whois
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dnstwist"
  ];

  meta = with lib; {
    description = "Domain name permutation engine for detecting homograph phishing attacks";
    mainProgram = "dnstwist";
    homepage = "https://github.com/elceef/dnstwist";
    changelog = "https://github.com/elceef/dnstwist/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
