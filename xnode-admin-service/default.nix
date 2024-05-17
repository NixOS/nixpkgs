{ pkgs, lib, stdenv, buildPythonPackage, fetchFromGitHub, py,  }:

buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "v${version}";
    sha256 = "09lr38d9f9y9dk7g0mjhwx3qsg8dv12pdrpqb888k2njjk7a862r"; # Unfinished commit
  };

  propagatedBuildInputs = [
    gitpython
  ];

  meta = with lib; {
      homepage = "https://openmesh.network/";
      description = "Agent service for Xnode reconfiguration and management";
      license = with licenses; [ x ];
      maintainers = with maintainers; [ harrys522 ];
    };
}