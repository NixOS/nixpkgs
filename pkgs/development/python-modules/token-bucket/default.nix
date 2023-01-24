{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest-runner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "token-bucket";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = pname;
    rev = version;
    sha256 = "0a703y2d09kvv2l9vq7vc97l4pi2wwq1f2hq783mbw2238jymb3m";
  };

  nativeBuildInputs = [
    pytest-runner
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Token Bucket Implementation for Python Web Apps";
    homepage = "https://github.com/falconry/token-bucket";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
