{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, python3Packages ? pkgs.python3Packages
, fetchFromGitHub ? pkgs.fetchFromGitHub
}:

python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "8a6e20a74ee62ea88d3374d94de3dad7fa1abdb6";
    sha256 = "1a16kf0rxvjmwhwgmflk3qffjcs82h3svm3z81xm9cqb7mhj4vbq"; # Unfinished commit
  };

  nativeBuildInputs = [
    pkgs.python311Packages.hatchling
  ];

  propagatedBuildInputs = [
    pkgs.python311Packages.gitpython
  ];


  meta = with lib; {
      homepage = "https://openmesh.network/";
      description = "Agent service for Xnode reconfiguration and management";
      #license = with licenses; [ x ];
      maintainers = with maintainers; [ harrys522 ];
    };
}