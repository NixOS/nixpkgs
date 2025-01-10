{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "tess";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5Ic06+K7CWRh1t2v3aJ5JlBACvHXqQyYzvU71jZJFtI=";
  };

  buildInputs = [ cython ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  meta = with lib; {
    description = "Module for calculating and analyzing Voronoi tessellations";
    homepage = "https://tess.readthedocs.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
