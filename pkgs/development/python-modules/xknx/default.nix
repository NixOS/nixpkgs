{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
, ifaddr
, voluptuous
, pyyaml
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xknx";
  version = "0.21.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-rtR77b4/cgDA6rf/Q+ecuKI5bl7N4YMim8TeQ7ovKhI=";
  };

  propagatedBuildInputs = [
    cryptography
    ifaddr
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xknx"
  ];

  disabledTests = [
    # Test requires network access
    "test_scan_timeout"
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
