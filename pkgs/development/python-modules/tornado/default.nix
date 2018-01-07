{ lib
, python
, buildPythonPackage
, fetchPypi
, backports_abc
, backports_ssl_match_hostname
, certifi
, singledispatch
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "4.5.3";
  name = "${pname}-${version}";

  propagatedBuildInputs = [ backports_abc backports_ssl_match_hostname certifi singledispatch ];

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  checkPhase = ''
    ${python.interpreter} -m unittest discover *_test.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d14e47eab0e15799cf3cdcc86b0b98279da68522caace2bd7ce644287685f0a";
  };
}
