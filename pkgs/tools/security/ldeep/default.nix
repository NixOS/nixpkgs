{ lib
<<<<<<< HEAD
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.34";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "franc-pentest";
    repo = "ldeep";
    rev = "refs/tags/${version}";
    hash = "sha256-Gskbxfqp2HqI6rCEiuT0lgHQtD0rZjtLgH3idEkfmjc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    commandparse
    cryptography
    dnspython
    ldap3
    pycryptodomex
    six
=======
, buildPythonApplication
, fetchPypi
, commandparse
, dnspython
, ldap3
, termcolor
, tqdm
}:

buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MYVC8fxLW85n8uZVMhb2Zml1lQ8vW9gw/eRLcmemQx4=";
  };

  propagatedBuildInputs = [
    commandparse
    dnspython
    ldap3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    termcolor
    tqdm
  ];

  # no tests are present
  doCheck = false;
<<<<<<< HEAD

  pythonImportsCheck = [
    "ldeep"
  ];
=======
  pythonImportsCheck = [ "ldeep" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "In-depth LDAP enumeration utility";
    homepage = "https://github.com/franc-pentest/ldeep";
<<<<<<< HEAD
    changelog = "https://github.com/franc-pentest/ldeep/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
