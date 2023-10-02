{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "tlds";
  version = "2023080900";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    rev = "refs/tags/${version}";
    hash = "sha256-n6SGOBkwGrjnH01yFd9giODUDkPGVMwB1H/fozzwQwU=";
  };

  pythonImportsCheck = [
    "tlds"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Automatically updated list of valid TLDs taken directly from IANA";
    homepage = "https://github.com/mweinelt/tlds";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
