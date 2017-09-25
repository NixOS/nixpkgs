{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm
, six, pytz}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "tempora";
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b29d19r8h5my9kzzywi9khn1qzvk3qzp08k0f4rrsa7qks930l4";
  };

  doCheck = false;

  buildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ six pytz ];
}
