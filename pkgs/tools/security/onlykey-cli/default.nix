{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "onlykey-cli";
  version = "1.2.9";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "onlykey";
    sha256 = "sha256-92CzDZgtmww0eABtjeBo6HNQ00sijWakjXLPJiOXY/A=";
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
