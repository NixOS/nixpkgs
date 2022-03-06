{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "onlykey-cli";
  version = "1.2.6";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "onlykey";
    sha256 = "sha256-Uf4FASugl5r5n2G6pZQ8W1PmbON+KombwlIzi00XANc=";
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
  pythonImportsCheck = [ "onlykey.cli" ];

  meta = with lib; {
    description = "OnlyKey client and command-line tool";
    homepage = "https://github.com/trustcrypto/python-onlykey";
    license = licenses.mit;
    maintainers = with maintainers; [ ranfdev ];
  };
}
