{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "versiontools";
  version = "1.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xhl6kl7f4srgnw6zw4lr8j2z5vmrbaa83nzn2c9r2m1hwl36sd9";
  };

  doCheck = (!isPy3k);

  meta = with lib; {
    homepage = "https://launchpad.net/versiontools";
    description = "Smart replacement for plain tuple used in __version__";
    license = licenses.lgpl2;
  };

}
