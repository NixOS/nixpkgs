{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, six }:

buildPythonPackage rec {
  version = "1.4";
  pname = "tempora";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ysvns22i5hzhl5ln4n86bq10j8xwvd09z8qw1zjr3s0fj3lynza";
  };

  doCheck = false;

  buildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ six ];
}
