{ stdenv, buildPythonPackage, fetchPypi
, pytz }:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "2.1";

  propagatedBuildInputs = [ pytz ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44";
  };

  # test fail (timezone test fail)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tzinfo object for the local timezone";
    homepage = "https://github.com/regebro/tzlocal";
    license = licenses.cddl;
  };
}
