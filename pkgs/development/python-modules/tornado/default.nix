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
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "5.1";


  propagatedBuildInputs = [ backports_abc  certifi singledispatch ]
    ++ lib.optional (pythonOlder "3.5") backports_ssl_match_hostname
    ++ lib.optional (pythonOlder "3.2") futures;

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  checkPhase = ''
    ${python.interpreter} -m unittest discover *_test.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f66a2172cb947387193ca4c2c3e19131f1c70fa8be470ddbbd9317fd0801582";
  };

  meta = {
    description = "A web framework and asynchronous networking library";
    homepage = http://www.tornadoweb.org/;
    license = lib.licenses.asl20;
  };
}
