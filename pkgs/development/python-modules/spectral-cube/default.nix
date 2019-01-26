{ lib
, fetchPypi
, buildPythonPackage
, astropy
, radio_beam
, pytest }:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.4.3";

  doCheck = false; # the tests requires several pytest plugins that are not in nixpkgs

  src = fetchPypi {
    inherit pname version;
    sha256 = "057g3mzlg5cy4wg2hh3p6gssn93rs6i7pswzhldvcq4k8m8hsl3b";
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


