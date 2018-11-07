{ stdenv
, buildPythonPackage
, fetchPypi
, traitlets
, pytest
, xarray
, pandas
, numpy
, nose
}:

buildPythonPackage rec {
  pname = "traittypes";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be6fa26294733e7489822ded4ae25da5b4824a8a7a0e0c2dccfde596e3489bd6";
  };

  checkInputs = [ pytest xarray pandas numpy nose ];
  propagatedBuildInputs = [ traitlets ];

  meta = with stdenv.lib; {
    description = "Scipy trait types";
    homepage = http://ipython.org;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
