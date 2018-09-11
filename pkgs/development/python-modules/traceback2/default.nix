{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, linecache2
}:

buildPythonPackage rec {
  version = "1.4.0";
  pname = "traceback2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05acc67a09980c2ecfedd3423f7ae0104839eccb55fc645773e1caa0951c3030";
  };

  propagatedBuildInputs = [ pbr linecache2 ];

  # circular dependencies for tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A backport of traceback to older supported Pythons";
    homepage = https://pypi.python.org/pypi/traceback2/;
    license = licenses.psfl;
    maintainers = [ maintainers.costrouc ];
  };
}
