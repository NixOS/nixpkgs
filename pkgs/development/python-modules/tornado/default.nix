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
  version = "4.5.1";
  name = "${pname}-${version}";

  propagatedBuildInputs = [ backports_abc backports_ssl_match_hostname certifi singledispatch ];

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  checkPhase = ''
    ${python.interpreter} -m unittest discover *_test.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "db0904a28253cfe53e7dedc765c71596f3c53bb8a866ae50123320ec1a7b73fd";
  };
}
