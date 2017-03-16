{ lib
, fetchPypi
, buildPythonPackage
, appdirs
, six
, packaging
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "34.3.2";
  name = "${pname}-${version}";

  format = "wheel";       # Wheel required for bootstrapping setuptools.
  catchConflicts = false; # For bootstrapping
  src = fetchPypi {
    inherit pname version format;
    sha256 = "6483f8412313ec787fa71379147a4605d3b1cc303c3648d02542a9160d3db72b";
  };

  propagatedBuildInputs = [ appdirs six packaging ];
  installFlags = [ "--ignore-installed" "--no-dependencies" ];

  meta = with lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = http://pypi.python.org/pypi/setuptools;
    license = with lib.licenses; [ psfl zpt20 ];
    platforms = platforms.all;
    priority = 10;
  };
}
