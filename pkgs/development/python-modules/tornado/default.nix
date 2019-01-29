{ lib
, python
, buildPythonPackage
, fetchPypi
, backports_abc
, backports_ssl_match_hostname
, certifi
, singledispatch
, pythonOlder
, futures
, version ? "5.1"
}:

let
  versionMap = {
    "4.5.3" = {
      sha256 = "02jzd23l4r6fswmwxaica9ldlyc2p6q8dk6dyff7j58fmdzf853d";
    };
    "5.1" = {
      sha256 = "4f66a2172cb947387193ca4c2c3e19131f1c70fa8be470ddbbd9317fd0801582";
    };
  };
in

with versionMap.${version};

buildPythonPackage rec {
  pname = "tornado";
  inherit version;

  propagatedBuildInputs = [ backports_abc  certifi singledispatch ]
    ++ lib.optional (pythonOlder "3.5") backports_ssl_match_hostname
    ++ lib.optional (pythonOlder "3.2") futures;

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  checkPhase = ''
    ${python.interpreter} -m unittest discover *_test.py
  '';

  src = fetchPypi {
    inherit pname sha256 version;
  };

  meta = {
    description = "A web framework and asynchronous networking library";
    homepage = http://www.tornadoweb.org/;
    license = lib.licenses.asl20;
  };
}
