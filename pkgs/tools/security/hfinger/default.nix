{ lib
, fetchFromGitHub
, python3
, wireshark-cli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hfinger";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "hfinger";
    rev = "refs/tags/v${version}";
    hash = "sha256-gxwirAqtY4R3KDHyNmDIknABO+SFuoDua9nm1UyXbxA=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    fnvhash
    python-magic
  ] ++ [
    wireshark-cli
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hfinger"
  ];

  meta = with lib; {
    description = "Fingerprinting tool for HTTP requests";
    mainProgram = "hfinger";
    homepage = "https://github.com/CERT-Polska/hfinger";
    changelog = "https://github.com/CERT-Polska/hfinger/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
