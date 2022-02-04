{ lib
, buildPythonPackage
, fetchFromGitHub
, netifaces
, voluptuous
, pyyaml
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xknx";
  version = "0.19.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = pname;
    rev = version;
    sha256 = "sha256-CmiibJc8cy0NuGVS9CEsML2DgVRIsNmWsqp9nmzInAA=";
  };

  propagatedBuildInputs = [
    voluptuous
    netifaces
    pyyaml
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xknx"
  ];

  meta = with lib; {
    description = "KNX Library Written in Python";
    longDescription = ''
      XKNX is an asynchronous Python library for reading and writing KNX/IP
      packets. It provides support for KNX/IP routing and tunneling devices.
    '';
    homepage = "https://github.com/XKNX/xknx";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
