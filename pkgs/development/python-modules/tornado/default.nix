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
  version = "5.0.1";


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
    sha256 = "3e9a2333362d3dad7876d902595b64aea1a2f91d0df13191ea1f8bca5a447771";
  };

  meta = {
    description = "A web framework and asynchronous networking library";
    homepage = http://www.tornadoweb.org/;
    license = lib.licenses.asl20;
  };
}
