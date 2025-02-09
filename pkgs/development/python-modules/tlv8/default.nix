{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tlv8";
  version = "0.10.0";
  format = "setuptools";

  # pypi does not contain test files
  src = fetchFromGitHub {
    owner = "jlusiardi";
    repo = "tlv8_python";
    rev = "v${version}";
    sha256 = "sha256-G35xMFYasKD3LnGi9q8wBmmFvqgtg0HPdC+y82nxRWA=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tlv8"
  ];

  meta = with lib; {
    description = "Type-Length-Value8 (TLV8) for Python";
    longDescription = ''
      Python module to handle type-length-value (TLV) encoded data 8-bit type, 8-bit length, and N-byte
      value as described within the Apple HomeKit Accessory Protocol Specification Non-Commercial Version
      Release R2.
    '';
    homepage = "https://github.com/jlusiardi/tlv8_python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
  };
}
