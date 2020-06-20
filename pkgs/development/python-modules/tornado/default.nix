{ lib
, python
, buildPythonPackage
, fetchPypi
, backports_abc
, backports_ssl_match_hostname
, certifi
, singledispatch
, futures
, isPy27
, version ? "6.0.4"
}:

let
  versionMap = {
    "4.5.3" = {
      sha256 = "02jzd23l4r6fswmwxaica9ldlyc2p6q8dk6dyff7j58fmdzf853d";
    };
    "6.0.4" = {
      sha256 = "0fe2d45ba43b00a41cd73f8be321a44936dc1aba233dee979f17a042b83eb6dc";
    };
  };
in

with versionMap.${version};

buildPythonPackage rec {
  pname = "tornado";
  inherit version;

  propagatedBuildInputs = lib.optionals isPy27 [ backports_abc certifi singledispatch backports_ssl_match_hostname futures ];

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  checkPhase = ''
    ${python.interpreter} -m unittest discover *_test.py
  '';

  src = fetchPypi {
    inherit pname sha256 version;
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "A web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = lib.licenses.asl20;
  };
}
