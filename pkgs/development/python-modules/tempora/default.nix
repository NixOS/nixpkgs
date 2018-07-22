{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm
, six, pytz}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "tempora";
  version = "1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4848df474c9d7ad9515fbeaadc88e48843176b4b90393652156ccff613bcaeb1";
  };

  doCheck = false;

  buildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ six pytz ];
}
