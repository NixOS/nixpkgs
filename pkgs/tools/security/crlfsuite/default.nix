{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "crlfsuite";
  version = "2.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Nefcore";
    repo = "CRLFsuite";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-wWXqeQ6rq4yMG1V9f9JGE91Se8VuU8gpahmYyNTtkmo=";
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
