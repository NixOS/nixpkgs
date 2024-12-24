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
  version = "1.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mRestRJukaf7ti3vIs/MM/R+zpGmK551j5HAM2chBsE=";
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
    maintainers = with maintainers; [ davidtwco ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
