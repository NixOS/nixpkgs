{ lib
, fetchFromGitHub
, buildPythonPackage
, aplpy
, astropy
, radio_beam
, pytest
, pytest-astropy
, astropy-helpers
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.4.5";

  # Fetch from GitHub instead of PyPi, as 0.4.5 isn't available in PyPi
  src = fetchFromGitHub {
    owner = "radio-astro-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xc1m6vpl0bm600fx9vypa7zcvwg7yvhgn0w89y6v9d1vl0qcs7z";
  };

  propagatedBuildInputs = [ astropy radio_beam ];

  nativeBuildInputs = [ astropy-helpers ];

  checkInputs = [ aplpy pytest pytest-astropy ];

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
    homepage = "http://radio-astro-tools.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
  };
}

