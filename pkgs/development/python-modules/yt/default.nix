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
  version = "4.0.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6219cbf971871320a13679a57722c0363e50db5e6d4d64ea9d197461b2a7f70f";
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
