{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pyyaml
}:

buildPythonPackage rec {
  pname = "yacs";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "rbgirshick";
    repo = "yacs";
    rev = "v${version}";
    hash = "sha256-nO8FL4tTkfTthXYXxXORLieFwvn780DDxfrxC9EUUJ0=";
  };

  propagatedBuildInputs = [ pyyaml ];

  pythonImportsCheck = [ "yacs" ];
  checkPhase = ''
    ${python.interpreter} yacs/tests.py
  '';

  meta = with lib; {
    description = "Yet Another Configuration System";
    homepage = "https://github.com/rbgirshick/yacs";
    license = licenses.apsl20;
    maintainers = with maintainers; [ lucasew ];
  };
}
