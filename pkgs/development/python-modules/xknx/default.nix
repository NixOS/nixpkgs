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
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = pname;
    rev = version;
    sha256 = "0cd7y00idbdinq1qibw41vv2nxr9lz8v6r3zig93l85kj5xwv6zy";
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
