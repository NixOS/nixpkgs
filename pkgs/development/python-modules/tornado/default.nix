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
  version = "4.5.2";
  name = "${pname}-${version}";

  propagatedBuildInputs = [ backports_abc backports_ssl_match_hostname certifi singledispatch ];

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  checkPhase = ''
    ${python.interpreter} -m unittest discover *_test.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fb8e494cd46c674d86fac5885a3ff87b0e283937a47d74eb3c02a48c9e89ad0";
  };
}
