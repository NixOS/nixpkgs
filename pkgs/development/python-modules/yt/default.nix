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
  version = "3.6.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "be454f9d05dcbe0623328b4df43a1bfd1f0925e516be97399710452931a19bb0";
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
