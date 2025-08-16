{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  paramiko,
  pytestCheckHook,
  tornado,
}:

buildPythonPackage rec {
  pname = "webssh";
  version = "1.6.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K85buvIGrTRZEMfk3IAks8QY5oHJ9f8JjxgCvv924QA=";
  };

  patches = [
    ./remove-typo-in-test-case.patch
  ];

  propagatedBuildInputs = [
    paramiko
    tornado
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "webssh" ];

  meta = with lib; {
    description = "Web based SSH client";
    mainProgram = "wssh";
    homepage = "https://github.com/huashengdun/webssh/";
    changelog = "https://github.com/huashengdun/webssh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
