{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "token-bucket";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dazqJRpC8FUHOhgKFzDnIl5CT2L74J2o2Hsm0IQf4Cg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Token Bucket Implementation for Python Web Apps";
    homepage = "https://github.com/falconry/token-bucket";
    changelog = "https://github.com/falconry/token-bucket/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
