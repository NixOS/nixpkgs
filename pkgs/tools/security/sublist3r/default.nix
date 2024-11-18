{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "sublist3r";
  version = "1.1"; # Version tag or commit hash of the repository

  src = fetchFromGitHub {
    owner = "aboul3la";
    repo = "Sublist3r";
    rev = "master"; # Or specify a commit hash for a specific version
    sha256 = "nrnb3jAIHw6WXR7VLNmi1YdfMBzHEIiMlGSbrvEi6Uc=";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    dnspython
  ];

  doCheck = false;

  meta = with lib; {
    description = "Fast subdomains enumeration tool for penetration testers";
    homepage = "https://github.com/aboul3la/Sublist3r";
    license = licenses.gpl2Oss;
    maintainers = [ maintainers.kpanuragh ];
  };
}
