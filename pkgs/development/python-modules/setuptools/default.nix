{ lib
, fetchPypi
, buildPythonPackage
, appdirs
, six
, packaging
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "35.0.0";
  name = "${pname}-${version}";

  format = "wheel";       # Wheel required for bootstrapping setuptools.
  catchConflicts = false; # For bootstrapping
  src = fetchPypi {
    inherit pname version format;
    sha256 = "b427014a0cf196e57727e141899c20381051233094783aa6274780a100eb65d9";
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
