{ stdenv, buildPythonPackage, fetchPypi
, pytz }:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "2.0.0";

  propagatedBuildInputs = [ pytz ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "949b9dd5ba4be17190a80c0268167d7e6c92c62b30026cf9764caf3e308e5590";
  };

  # test fail (timezone test fail)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tzinfo object for the local timezone";
    homepage = https://github.com/regebro/tzlocal;
    license = licenses.cddl;
  };
}
