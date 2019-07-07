{ lib
, fetchPypi
, buildPythonPackage
, astropy
, radio_beam
, pytest }:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.4.4";

  doCheck = false; # the tests requires several pytest plugins that are not in nixpkgs

  src = fetchPypi {
    inherit pname version;
    sha256 = "9051ede204b1e25b6358b5e0e573b624ec0e208c24eb03a7ed4925b745c93b5e";
  };

  propagatedBuildInputs = [ astropy radio_beam pytest ];

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = http://radio-astro-tools.github.io;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
  };
}


