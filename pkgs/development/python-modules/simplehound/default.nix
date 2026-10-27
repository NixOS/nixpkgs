{
  lib,
  requests,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "simplehound";
  version = "0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "robmarkcole";
    repo = "simplehound";
    rev = "v${version}";
    hash = "sha256-kOO0Iyx7vD6jPisyRxWdj2rtNL1ZbQ+c9YaCWWUftaw=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "simplehound" ];

  meta = {
    description = "Python API for Sighthound";
    homepage = "https://github.com/robmarkcole/simplehound";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
