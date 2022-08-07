{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "crlfsuite";
  version = "2.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Nefcore";
    repo = "CRLFsuite";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Olwt19HauTG2HuG4Pro0ImVbQtWqCgx9gV+2RtePT/8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    requests
  ];

  # No tests present
  doCheck = false;

  pythonImportsCheck = [
    "crlfsuite"
  ];

  meta = with lib; {
    description = "CRLF injection (HTTP Response Splitting) scanner";
    homepage = "https://github.com/Nefcore/CRLFsuite";
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b fab ];
  };
}
