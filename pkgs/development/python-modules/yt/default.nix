{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
, setuptools
, sympy
, numpy
, ipython
, hdf5
, nose
, cython
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "yt";
  version = "3.6.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "effb00536f19fd2bdc18f67dacd5550b82066a6adce5b928f27a01d7505109ec";
  };

  buildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    matplotlib
    setuptools
    sympy
    numpy
    ipython
    hdf5
  ];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    cd $out/${python.sitePackages}
    HOME=$(mktemp -d) nosetests yt
  '';

  meta = with lib; {
    description = "An analysis and visualization toolkit for volumetric data";
    homepage = "https://github.com/yt-project/yt";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
