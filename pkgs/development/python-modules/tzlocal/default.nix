{ stdenv, buildPythonPackage, fetchPypi
, pytz }:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "1.5.1";

  propagatedBuildInputs = [ pytz ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ebeb848845ac898da6519b9b31879cf13b6626f7184c496037b818e238f2c4e";
  };

  # test fail (timezone test fail)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tzinfo object for the local timezone";
    homepage = https://github.com/regebro/tzlocal;
    license = licenses.cddl;
  };
}
