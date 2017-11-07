{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm
, six, pytz}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "tempora";
  version = "1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ea980c63be54f83d2a466fccc6eeef96a409f74c5034764fb328b0d43247e96";
  };

  doCheck = false;

  buildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ six pytz ];
}
