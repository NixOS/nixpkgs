{ lib
, python
, buildPythonPackage
, fetchPypi
, backports_abc ? null
, backports_ssl_match_hostname ? null
, certifi ? null
, singledispatch ? null
, futures ? null
, isPy27
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "5.1.1";

  propagatedBuildInputs = lib.optionals isPy27 [ backports_abc certifi singledispatch backports_ssl_match_hostname futures ];

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  checkPhase = ''
    ${python.interpreter} -m unittest discover *_test.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e5158d97583502a7e2739951553cbd88a72076f152b4b11b64b9a10c4c49409";
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "A web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = lib.licenses.asl20;
  };
}
