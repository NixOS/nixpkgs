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
  version = "5.0.2";


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
    sha256 = "1b83d5c10550f2653380b4c77331d6f8850f287c4f67d7ce1e1c639d9222fbc7";
  };

  meta = {
    description = "A web framework and asynchronous networking library";
    homepage = http://www.tornadoweb.org/;
    license = lib.licenses.asl20;
  };
}
