{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, pytestCheckHook
, tornado
}:

buildPythonPackage rec {
  pname = "webssh";
  version = "1.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g3RRQUWbjHRaZRVekmETcrHYeVIIpeteCCh7o28jBLY=";
  };

  propagatedBuildInputs = [
    paramiko
    tornado
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "webssh"
  ];

  disabledTests = [
    # Test fails with AttributeError (possibly related to paramiko update)
    "test_app_with_bad_host_key"
  ];

  meta = with lib; {
    description = "Web based SSH client";
    homepage = "https://github.com/huashengdun/webssh/";
    changelog = "https://github.com/huashengdun/webssh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
    broken = stdenv.isDarwin;
  };
}
