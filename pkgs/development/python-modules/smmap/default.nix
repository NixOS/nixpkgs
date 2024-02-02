{ lib
, fetchPypi
, buildPythonPackage
, setuptools
, nosexcover
}:

buildPythonPackage rec {
  pname = "smmap";
  version = "6.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jXkCjqbMEx2l6rCZpdlamY1DxneZVv/+O0VQQJEQdto=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    nosexcover
  ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
