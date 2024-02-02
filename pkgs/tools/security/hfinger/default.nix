{ lib
, fetchFromGitHub
, python3
, wireshark-cli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hfinger";
  version = "0.2.2";
  disabled = python3.pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-gxwirAqtY4R3KDHyNmDIknABO+SFuoDua9nm1UyXbxA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    fnvhash
    python-magic
  ] ++ [
    wireshark-cli
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "hfinger" ];

  meta = with lib; {
    description = "Fingerprinting tool for HTTP requests";
    homepage = "https://github.com/CERT-Polska/hfinger";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
