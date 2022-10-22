{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, paramiko
, pytestCheckHook
, tornado
}:

buildPythonPackage rec {
  pname = "webssh";
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yqjwahh2METXD83geTGt5sUL+vmxbrYxj4KtwTxbD94=";
  };

  propagatedBuildInputs = [
    paramiko
    tornado
  ];

  checkInputs = [
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
    broken = stdenv.isDarwin;
    description = "Web based SSH client";
    homepage = "https://github.com/huashengdun/webssh/";
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
