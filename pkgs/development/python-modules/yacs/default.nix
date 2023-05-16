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
<<<<<<< HEAD
    license = licenses.asl20;
=======
    license = licenses.apsl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ lucasew ];
  };
}
