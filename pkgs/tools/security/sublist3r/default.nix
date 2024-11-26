{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "sublist3r";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "aboul3la";
    repo = "Sublist3r";
    rev = "refs/tags/${version}";
    hash = "";
  };

  dependencies = with python3Packages; [
    requests
    dnspython
  ];

  doCheck = false;

  meta = {
    description = "Fast subdomains enumeration tool for penetration testers";
    homepage = "https://github.com/aboul3la/Sublist3r";
    license = lib.licenses.gpl2Oss;
    maintainers = with lib.maintainers [ kpanuragh ];
  };
}
