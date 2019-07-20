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
}:

buildPythonPackage rec {
  pname = "yt";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8ef8eceb934dc189d63dc336109fad3002140a9a32b19f38d1812d5d5a30d71";
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
    homepage = https://github.com/yt-project/yt;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
