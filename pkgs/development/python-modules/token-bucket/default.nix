{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestrunner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "token-bucket";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = pname;
    rev = version;
    sha256 = "0kv8j2ab4knvzik2di66bgjwjxdslm2i0hjy35kn9z0dazni585s";
  };

  nativeBuildInputs = [
    pytestrunner
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Token Bucket Implementation for Python Web Apps";
    homepage = "https://github.com/falconry/token-bucket";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
