{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "onlykey-cli";
  version = "1.2.10";

  src = fetchPypi {
    inherit version;
    pname = "onlykey";
    sha256 = "sha256-ZmQnyZx9YlIIxMMdZ0U2zb+QANfcwrtG7iR1LpgzmBQ=";
  };

  propagatedBuildInputs = with python3Packages; [
    aenum
    cython
    ecdsa
    hidapi
    onlykey-solo-python
    prompt-toolkit
    pynacl
    six
  ];

  # Requires having the physical onlykey (a usb security key)
  doCheck = false;
  pythonImportsCheck = [ "onlykey.client" ];

  meta = with lib; {
    description = "OnlyKey client and command-line tool";
    homepage = "https://github.com/trustcrypto/python-onlykey";
    license = licenses.mit;
    maintainers = with maintainers; [ ranfdev ];
  };
}
