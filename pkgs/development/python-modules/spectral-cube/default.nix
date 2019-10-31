{ lib
, fetchPypi
, buildPythonPackage
, astropy
, radio_beam
, pytest
, pytest-astropy
, astropy-helpers
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9051ede204b1e25b6358b5e0e573b624ec0e208c24eb03a7ed4925b745c93b5e";
  };

  propagatedBuildInputs = [ astropy radio_beam ];

  nativeBuildInputs = [ astropy-helpers ];

  checkInputs = [ pytest pytest-astropy ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  # Tests must be run in the build directory
  checkPhase = ''
    cd build/lib
    pytest
  '';

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = http://radio-astro-tools.github.io;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
    broken = true;
  };
}


