{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap";
  version = "6.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jXkCjqbMEx2l6rCZpdlamY1DxneZVv/+O0VQQJEQdto=";
  };

  nativeCheckInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
