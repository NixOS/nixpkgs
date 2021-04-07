{ lib
, fetchPypi
, buildPythonPackage
, aplpy
, joblib
, astropy
, radio_beam
, pytest
, pytest-astropy
, astropy-helpers
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.5.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17zisr26syfb8kn89xj17lrdycm0hsmy5yp5zrn236wgd8rjriki";
  };

  nativeBuildInputs = [ astropy-helpers ];
  propagatedBuildInputs = [ astropy radio_beam joblib ];
  checkInputs = [ aplpy pytest pytest-astropy ];

  checkPhase = ''
    pytest spectral_cube
  '';

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "http://radio-astro-tools.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
  };
}

