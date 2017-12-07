{ stdenv, buildPythonPackage, fetchPypi
, tzlocal, pytz }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "tzlocal";
  version = "1.4";

  propagatedBuildInputs = [ pytz ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n9hw4kqblyc0avzwi26rqmvyk9impb608rvy11qifmigy7r18h5";
  };

  # test fail (timezone test fail)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tzinfo object for the local timezone";
    homepage = https://github.com/regebro/tzlocal;
    license = licenses.cddl;
  };
}
