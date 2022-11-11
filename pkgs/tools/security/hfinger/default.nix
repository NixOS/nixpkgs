{ lib
, fetchFromGitHub
, python3
, wireshark-cli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hfinger";
  version = "0.2.1";
  disabled = python3.pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QKnrprDDBq+D8N1brkqgcfK4E+6ssvgPtRaSxkF0C84=";
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
