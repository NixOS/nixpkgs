{ lib
, pkgs
, python3Packages
, fetchFromGitHub
, fetchpatch
, argparse
}: let
  pname = "hdl_checker";
  # Version is a development commit because the release version
  # won't compile on NixOS
  version = "0.7.5-develop";
in python3Packages.buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "suoto";
    repo  = "hdl_checker";
    rev   = "12983254962ca2d221d5e755726528aedeca27e2";
    hash  = "sha256-2vvJEEjptKxfIc6bOiUXDh70wEdK4YppWXSPxeazE40=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/suoto/hdl_checker/pull/101.patch";
      hash = "sha256-cQ9RJt2H3yD19i9ya4vyC1IHuc/7gbl1c+5+GiJbtSA=";
    })
    ./remove_argparse_from_pip.diff
  ];

  propagatedBuildInputs = (with python3Packages; [
    future
    argcomplete
    prettytable
    waitress
    pygls
    bottle
    six
    tabulate
    requests
    mock

    typing-extensions
  ]) ++ [
    argparse
  ];

  # Depends on 'unittest2' which is DEPRECATED AND BROKEN
  # See: https://github.com/NixOS/nixpkgs/pull/203986
  doCheck = false;

  meta = with lib; {
    description = "HDL code checker";
    homepage    = "https://github.com/suoto/hdl_checker";
    license     = licenses.gpl3Only;
    maintainers = [ maintainers.nikp123 ];
  };
}

