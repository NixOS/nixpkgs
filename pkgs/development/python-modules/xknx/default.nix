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
  version = "0.18.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = pname;
    rev = version;
    sha256 = "sha256-7jfZtncjcYaAS/7N06FWXh4qSTH6y+VdFx3kKyQxIbM=";
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

  pythonImportsCheck = [ "xknx" ];

  meta = with lib; {
    description = "KNX Library Written in Python";
    longDescription = ''
      XKNX is an asynchronous Python library for reading and writing KNX/IP
      packets. It provides support for KNX/IP routing and tunneling devices.
    '';
    homepage = "https://github.com/XKNX/xknx";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
