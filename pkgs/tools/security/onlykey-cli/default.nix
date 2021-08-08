{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "onlykey-cli";
  version = "1.2.2";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "onlykey";
    sha256 = "1qkbgab5xlg7bd0jfzf8k5ppb1zhib76r050fiaqi5wibrqrfwdi";
  };

  # Requires having the physical onlykey (a usb security key)
  doCheck = false;
  propagatedBuildInputs =
    with python3Packages; [ hidapi aenum six prompt-toolkit pynacl ecdsa cython ];

  meta = with lib; {
    description = "OnlyKey client and command-line tool";
    homepage = "https://github.com/trustcrypto/python-onlykey";
    license = licenses.mit;
    maintainers = with maintainers; [ ranfdev ];
  };
}
