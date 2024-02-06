{ lib
, buildPythonPackage
, fetchPypi
, pbr
, linecache2
}:

buildPythonPackage rec {
  version = "1.4.0";
  format = "setuptools";
  pname = "traceback2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c1h3jas1jp1fdbn9z2mrgn3jj0hw1x3yhnkxp7jw34q15xcdb05";
  };

  propagatedBuildInputs = [ pbr linecache2 ];

  # circular dependencies for tests
  doCheck = false;

  meta = with lib; {
    description = "A backport of traceback to older supported Pythons";
    homepage = "https://pypi.python.org/pypi/traceback2/";
    license = licenses.psfl;
  };

}
