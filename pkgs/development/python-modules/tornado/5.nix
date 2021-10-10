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
  version = "6.1";

  propagatedBuildInputs = lib.optionals isPy27 [ backports_abc certifi singledispatch backports_ssl_match_hostname futures ];

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  checkPhase = ''
    ${python.interpreter} -m unittest discover *_test.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791";
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "A web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = lib.licenses.asl20;
  };
}
